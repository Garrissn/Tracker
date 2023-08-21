//
//  TrackerDataManager.swift
//  Tracker
//
//  Created by Игорь Полунин on 26.07.2023.
//

import Foundation
import CoreData



protocol TrackerDataManagerDelegate: AnyObject {
    func updateViewByController(_ update: TrackerCategoryStoreUpdate)
    func updateView(categories: [TrackerCategory], animating: Bool)
}

protocol TrackerDataManagerProtocol: AnyObject {
    var categories: [TrackerCategory] { get }
    var delegate: TrackerDataManagerDelegate? { get set }
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func fetchCategoriesFor(weekDay: String, animating: Bool)
    func fetchSearchCategories(textToSearch: String, weekDay: String)
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws
    func addTrackerRecord(forId: UUID, date: String) throws
    func deleteTrackerRecord(forId: UUID, date: String) throws
    func recordExists(forId: UUID, date: String) -> Bool
    func numberOfRecords(forId: UUID) -> Int
    func trackerIsPinned(isPinned: Bool, tracker: Tracker) throws
    func getTracker(at: IndexPath) throws -> Tracker
    func deleteTracker(tracker: Tracker) throws
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
            NSSortDescriptor(keyPath: \TrackerEntity.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil, cacheName: nil
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
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
       try trackerCategoryStore.addTrackerCategory(trackerCategory)
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
    
    func trackerIsPinned(isPinned: Bool, tracker: Tracker) throws {
        try trackerCategoryStore.trackerIsPinned(isPinned: isPinned, tracker: tracker)
    }
    func deleteTracker(tracker: Tracker) throws {
      try  trackerCategoryStore.deleteTracker(tracker: tracker)
    }
    
    
   
    func fetchCategoriesFor(weekDay: String, animating: Bool) {
        let predicate = NSPredicate(format: "ANY %K.%K == %@", #keyPath(TrackerEntity.schedule), #keyPath(ScheduleEntity.weekDay), weekDay)
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort { $0.title < $1.title }
        
        print("запрос1")
        delegate?.updateView(categories: trackerCategories, animating: animating)
    }
    private func checkIsPinned() {
        
    }
    func fetchSearchCategories(textToSearch: String, weekDay: String) {
        let textPredicate = NSPredicate(format: "ANY %K CONTAINS[c] %@", #keyPath(TrackerEntity.title), textToSearch)
       // let weekDayPredicate = NSPredicate(format: "ANY %K.%K CONTAINS[c] %@", #keyPath(TrackerEntity.schedule), #keyPath(ScheduleEntity.weekDay), weekDay )
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        textPredicate
        ])
        print("запрос2")
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort { $0.title < $1.title }
        
        delegate?.updateView(categories: trackerCategories, animating: true)
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataManager: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let insertedIndexes,
              let deletedIndexes,
              let updatedIndexes,
              let movedIndexes else { return }
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes,
            movedIndexes: movedIndexes
        )
        delegate?.updateViewByController(update)
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes?.append(newIndexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexes?.append(indexPath)
            }
        case .update:
            if let indexPath {
                updatedIndexes?.append(indexPath)
            }
        case .move:
            if let newIndexPath, let indexPath {
                movedIndexes?.append(.init(oldIndex: indexPath, newIndex: newIndexPath))
            }
        @unknown default:
            break
        }
    }
}



