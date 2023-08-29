//
//  TrackerDataManager.swift
//  Tracker
//
//  Created by Игорь Полунин on 26.07.2023.
//

import Foundation
import CoreData



protocol TrackerDataManagerDelegate: AnyObject {
    func updateView()
}

protocol TrackerDataManagerProtocol: AnyObject {
    var categories: [TrackerCategory] { get }
    var delegate: TrackerDataManagerDelegate? { get set }
    var numberOfTrackers: Int { get }
    var numberOfSections: Int { get }
    
    func numberOfRowsInSection(section: Int) -> Int
    func nameOfSection(section: Int) -> String
    func fetchCategory(title: String) -> TrackerCategoryEntity?
    
    func getTrackerCategoryName(indexPath: IndexPath) -> String
    func getTrackerCoreData(indexPath: IndexPath) -> TrackerEntity
    func getTrackerObject(indexPath: IndexPath) -> Tracker?
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func fetchCategoriesFor(weekDay: String, animating: Bool)
    func fetchSearchCategories(textToSearch: String, weekDay: String)
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws
    func addTrackerRecord(forId: UUID, date: String) throws
    func deleteTrackerRecord(forId: UUID, date: String) throws
    func recordExists(forId: UUID, date: String) -> Bool
    func numberOfRecords(forId: UUID) -> Int
    func trackerIsPinned(indexPath: IndexPath) throws
    func getTracker(at: IndexPath) throws -> Tracker
    func deleteTracker(tracker: Tracker) throws 
    func deleteTracker(trackerEntity: TrackerEntity) throws
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker
    func getCompletedTrackers() -> [TrackerRecord]
    func fetchTracker(id: String) -> TrackerEntity?
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity
    func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet
    func updateTracker(trackerEntity: TrackerEntity, trackerCategoryEntity: TrackerCategoryEntity, trackerTitle: String) throws
    func addTracker(tracker: Tracker, trackerCategoryEntity: TrackerCategoryEntity) throws
}

final class TrackerDataManager: NSObject { //берем трекеры из кордаты и конвертируем в трекеры и обратно
    var trackerStore: TrackerStoreProtocol
    var trackerCategoryStore: TrackerCategoryStoreProtocol
    var trackerRecordStore: TrackerRecordStoreProtocol
    var fetchResultController: NSFetchedResultsController<TrackerEntity>?
    weak var delegate: TrackerDataManagerDelegate?
    private var context: NSManagedObjectContext
    
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    private var movedIndexes: [TrackerCategoryStoreUpdate.Move]?
    
    
    init(trackerStore: TrackerStoreProtocol,
         trackerCategoryStore: TrackerCategoryStoreProtocol,
         trackerRecordStore: TrackerRecordStoreProtocol,
         context: NSManagedObjectContext) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.context = context
        
        super.init()
        
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerEntity.trackerCategory?.title, ascending: true)
            
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerEntity.trackerCategory.title),
            cacheName: nil
        )
        controller.delegate = self
        self.fetchResultController = controller
        try? controller.performFetch()
        
    }
}
// MARK: - TrackerDataManagerProtocol

extension TrackerDataManager: TrackerDataManagerProtocol {
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws {
        try trackerCategoryStore.addTrackerCategoryTitle(trackerCategory)
    }
    
    func addTracker(tracker: Tracker, trackerCategoryEntity: TrackerCategoryEntity) throws {
        do {
            try trackerStore.addTracker(tracker: tracker, trackerCategoryEntity: trackerCategoryEntity)
        } catch {
            fatalError("Failed to deleteTracker: \(error)")
        }
    }
    
    func updateTracker(trackerEntity: TrackerEntity, trackerCategoryEntity: TrackerCategoryEntity, trackerTitle: String) throws {
        do {
            try trackerStore.updateTracker(trackerEntity: trackerEntity, trackerCategoryEntity: trackerCategoryEntity, trackerTitle: trackerTitle)
        } catch {
            fatalError("Failed to addTracker: \(error)")
        }
    }
    
    func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet {
        trackerStore.convertScheduleArrayToScheduleEntity(weekDays)
    }
    
    func fetchTracker(id: String) -> TrackerEntity? {
        trackerStore.fetchTracker(id: id)
    }
    
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker {
        do {
            let tracker = try trackerStore.convertTrackerEntityToTracker(trackerEntity)
            return tracker
        } catch {
            fatalError("Failed to addTracker: \(error)")
        }
    }
    
    var categor: [TrackerCategoryEntity]  {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryEntity.title, ascending: true)]
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)
        try? fetchResultController.performFetch()
        
        
        guard let objects = fetchResultController.fetchedObjects else { return [] }
        return objects
    }
    
    func getTracker(at: IndexPath) throws -> Tracker {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerEntity.title, ascending: true)]
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)
        try? fetchResultController.performFetch()
        
        
        let trackerEntity = fetchResultController.object(at: at)
        let tracker = try trackerStore.convertTrackerEntityToTracker(trackerEntity)
        return tracker
    }
    
    
    var categories: [TrackerCategory]  {
        guard let objects = self.fetchResultController?.fetchedObjects else { return [] }
        do {
            var trackerCategories = try trackerCategoryStore.convertTrackerCategoryEntityToTrackerCategories(objects)
            trackerCategories.sort { $0.title < $1.title }
            return trackerCategories
        } catch {
            print("Error converting TrackerCategoryEntity to TrackerCategory: \(error)")
            return []
        }
    }
    
    func getTrackerCoreData(indexPath: IndexPath) -> TrackerEntity {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else {
            fatalError("Failed to fetch tracker entity at indexPath: \(indexPath)")
        }
        return trackerEntity
    }
    
    var numberOfSections: Int {
        fetchResultController?.sections?.count ?? 0
    }
    
    var numberOfTrackers: Int {
        fetchResultController?.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        fetchResultController?.sections?[section].numberOfObjects ?? 0
    }
    
    func nameOfSection(section: Int) -> String {
        fetchResultController?.sections?[section].name ?? ""
    }
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        try trackerCategoryStore.addTrackerCategory(trackerCategory)
    }
    
    func fetchCategory(title: String) -> TrackerCategoryEntity? {
        trackerCategoryStore.fetchCategory(title: title)
    }
    
    func getTrackerObject(indexPath: IndexPath) -> Tracker? {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else { return nil }
        guard let tracker = try? trackerStore.convertTrackerEntityToTracker(trackerEntity) else { return nil }
        return tracker
    }
    
    func getTrackerCategoryName(indexPath: IndexPath) -> String {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else {return " "}
        guard let categoryName = trackerEntity.trackerCategory?.title else { return "" }
        return categoryName
    }
    
    func addTrackerRecord(forId: UUID, date: String) throws {
        try trackerRecordStore.addRecord(forId: forId, date: date)
    }
    
    func deleteTrackerRecord(forId: UUID, date: String) throws {
        try trackerRecordStore.deleteRecord(forId: forId, date: date)
    }
    
    func recordExists(forId: UUID, date: String) -> Bool {
        trackerRecordStore.recordExists(forId: forId, date: date)
    }
    
    func numberOfRecords(forId: UUID) -> Int {
        trackerRecordStore.numberOfRecords(forId: forId)
    }
    
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity {
        do {
            let newCategory = try trackerCategoryStore.createCategory(category: category)
            return newCategory
        } catch {
            fatalError("Failed to create new category: \(error)")
        }
    }
    
    func trackerIsPinned(indexPath: IndexPath) throws {
        let trackerEntityToToggle = getTrackerCoreData(indexPath: indexPath)
        trackerEntityToToggle.isPinned.toggle()
        
        if trackerEntityToToggle.isPinned {
            trackerEntityToToggle.previousCategory = trackerEntityToToggle.trackerCategory?.title
            if let existedCategoryEntity = fetchCategory(title: "Закрепленные") {
                trackerEntityToToggle.trackerCategory = existedCategoryEntity
            } else {
                let newPinnedCategory = TrackerCategory(title: "Закрепленные", trackers: [])
                do {
                    let newPinnedCategoryEntity = try createCategory(category: newPinnedCategory)
                    trackerEntityToToggle.trackerCategory = newPinnedCategoryEntity
                } catch {
                    fatalError("Failed to togglePinForTracker: \(error)")
                }
            }          
        } else {
            guard let previousCategory = trackerEntityToToggle.previousCategory,
                  let previousCategoryEntity = fetchCategory(title: previousCategory)
            else { return }
            trackerEntityToToggle.trackerCategory = previousCategoryEntity
            trackerEntityToToggle.previousCategory = nil
        }
        do {
            try context.save()
        } catch {
            fatalError("Failed to togglePinForTracker: \(error)")
        }
    }
    
    func deleteTracker(tracker: Tracker) throws {
        try  trackerCategoryStore.deleteTracker(tracker: tracker)
    }
    
    func deleteTracker(trackerEntity: TrackerEntity) throws {
        do {
            try trackerStore.deleteTracker(trackerEntity: trackerEntity)
        } catch {
            fatalError("Failed to deleteTracker: \(error)")
        }
    }
    
    
    func getCompletedTrackers() -> [TrackerRecord]  {
        trackerRecordStore.getCompletedTrackers()
    }
    
    
    func fetchCategoriesFor(weekDay: String, animating: Bool) {
        let predicate = NSPredicate(format: "ANY %K.%K == %@", #keyPath(TrackerEntity.schedule), #keyPath(ScheduleEntity.weekDay), weekDay)
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort { $0.title < $1.title }
        
        print("запрос1")
        
    }
    
    func fetchSearchCategories(textToSearch: String, weekDay: String) {
        var predicates: [NSPredicate] = []
        
        let weekDayPredicate = NSPredicate(format: "ANY %K.%K CONTAINS[c] %@", #keyPath(TrackerEntity.schedule), #keyPath(ScheduleEntity.weekDay), weekDay )
        predicates.append(weekDayPredicate)
        if !textToSearch.isEmpty {
            let textPredicate = NSPredicate(format: "ANY %K CONTAINS[c] %@", #keyPath(TrackerEntity.title), textToSearch)
            predicates.append(textPredicate)
        }
        print("запрос2")
        do {
            fetchResultController?.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            try fetchResultController?.performFetch()
        } catch {
            fatalError("Failed to fetch data with Predicates in method addFiltersForFetchResultController: \(error)")
        }
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateView()
    }
}



