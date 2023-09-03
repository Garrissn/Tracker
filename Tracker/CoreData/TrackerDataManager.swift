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
    //func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    
    
    // func fetchCategoriesFor(weekDay: String, animating: Bool)
    func fetchSearchCategories(textToSearch: String, weekDay: Date)
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws
    func addTrackerRecord(forId: UUID, date: String) throws
    func deleteTrackerRecord(forId: UUID, date: String) throws
    func recordExists(forId: UUID, date: String) -> Bool
    func numberOfRecords(forId: UUID) -> Int
    func trackerIsPinned(indexPath: IndexPath) throws
    func getTracker(at: IndexPath) throws -> Tracker
    //func deleteTracker(tracker: Tracker) throws
    func deleteTracker(trackerEntity: TrackerEntity) throws
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker
    func getCompletedTrackers() -> [TrackerRecord]
    func fetchTracker(id: String) -> TrackerEntity?
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity
    //func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet
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
    
    
    var categories: [TrackerCategory]  {
        guard let objects = self.fetchResultController?.fetchedObjects else { return [] }
        do {
            var trackerCategories =  trackerCategoryStore.convertTrackerCategoryEntityToTrackerCategories(objects)
            trackerCategories.sort { $0.title < $1.title }
            return trackerCategories
        } catch {
            print("Error converting TrackerCategoryEntity to TrackerCategory: \(error)")
            return []
        }
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
    
    func fetchCategory(title: String) -> TrackerCategoryEntity? {
        trackerCategoryStore.fetchCategory(title: title)
    }
    
    func getTrackerCoreData(indexPath: IndexPath) -> TrackerEntity {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else {
            fatalError("Failed to fetch tracker entity at indexPath: \(indexPath)")
        }
        return trackerEntity
    }
    
    func getTrackerObject(indexPath: IndexPath) -> Tracker? {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else { return nil }
        guard let tracker = try? trackerStore.getTracker(from: trackerEntity) else { return nil }
        return tracker
    }
    
    func fetchSearchCategories(textToSearch: String, weekDay: Date) {
        var predicates: [NSPredicate] = []
        let dayNumber = WeekDay.getWeekDayInNumber(for: weekDay)
        
        let weekDayPredicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(TrackerEntity.schedule), dayNumber )
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
    
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws {
        try trackerCategoryStore.addTrackerCategoryTitle(trackerCategory)
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
    
    func getTracker(at: IndexPath) throws -> Tracker {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerEntity.title, ascending: true)]
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil)
        try? fetchResultController.performFetch()
        let trackerEntity = fetchResultController.object(at: at)
        let tracker = try trackerStore.getTracker(from: trackerEntity)
        return tracker
    }
    
    func deleteTracker(trackerEntity: TrackerEntity) throws {
        do {
            try trackerStore.deleteTracker(trackerEntity: trackerEntity)
        } catch {
            fatalError("Failed to deleteTracker: \(error)")
        }
    }
    
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker {
        try trackerStore.getTracker(from: trackerEntity)
    }
    
    
    func getCompletedTrackers() -> [TrackerRecord]  {
        trackerRecordStore.getCompletedTrackers()
    }
    
    func fetchTracker(id: String) -> TrackerEntity? {
        trackerStore.fetchTracker(id: id)
    }
    
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity {
        do {
            let newCategory = try trackerCategoryStore.createCategory(category: category)
            return newCategory
        } catch {
            fatalError("Failed to create new category: \(error)")
        }
    }
    
    func updateTracker(trackerEntity: TrackerEntity, trackerCategoryEntity: TrackerCategoryEntity, trackerTitle: String) throws {
        do {
            try trackerStore.updateTracker(trackerEntity: trackerEntity, trackerCategoryEntity: trackerCategoryEntity, trackerTitle: trackerTitle)
        } catch {
            fatalError("Failed to addTracker: \(error)")
        }
    }
    
    func addTracker(tracker: Tracker, trackerCategoryEntity: TrackerCategoryEntity) throws {
        do {
            try trackerStore.addTracker(tracker: tracker, trackerCategoryEntity: trackerCategoryEntity)
        } catch {
            fatalError("Failed to deleteTracker: \(error)")
        }
    }
    
    func getTrackerCategoryName(indexPath: IndexPath) -> String {
        guard let trackerEntity = fetchResultController?.object(at: indexPath) else {return " "}
        guard let categoryName = trackerEntity.trackerCategory?.title else { return "" }
        return categoryName
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
    
    
}
// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateView()
    }
}



