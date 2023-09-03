//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Игорь Полунин on 27.07.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func categoriesDidUpdate()
}

protocol TrackerCategoryStoreProtocol {
    func fetchCategory(title: String) -> TrackerCategoryEntity?
    func convertTrackerCategoryEntityToTrackerCategory(_ objects: [TrackerCategoryEntity]) throws -> [TrackerCategory]
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity])   -> [TrackerCategory]
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?)
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory]
    func trackerIsPinned(isPinned: Bool, tracker: Tracker) throws
    func deleteTracker(tracker: Tracker) throws
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var trackerStore: TrackerStoreProtocol
    private weak var trackerDataManager: NSFetchedResultsController<TrackerEntity>?
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var onTrackerCategoryAdded: (() -> Void)?
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStoreProtocol) {
        self.context = context
        self.trackerStore = trackerStore
    }
}
// MARK: - TrackerCategoryStoreProtocol

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?) {
        self.trackerDataManager = controller
    }
    
    func fetchCategory(title: String) -> TrackerCategoryEntity? {
        let request = TrackerCategoryEntity.fetchRequest()
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(TrackerCategoryEntity.title), title)
        
        guard let categories = try? context.fetch(request) else { return nil }
        return categories.first
    }
    
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws {
        let newCategory = TrackerCategoryEntity(context: context)
        newCategory.title = trackerCategory.title
        try context.save()
        onTrackerCategoryAdded?()
    }
    
    func createCategory(category: TrackerCategory) throws -> TrackerCategoryEntity {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        trackerCategoryEntity.title = category.title
        
        try context.save()
        return trackerCategoryEntity
    }
    
    func deleteTracker(tracker: Tracker) throws {
        let originTrackerFetchRequest = NSFetchRequest<TrackerEntity>(entityName: "TrackerEntity")
        originTrackerFetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerEntity.title), tracker.title)
        
        //  let scheduleFetchRequest = NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
        // scheduleFetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ScheduleEntity.trackers.title), tracker.title)
        
        //        do {
        ////            let scheduleTrackers = try context.fetch(scheduleFetchRequest)
        ////            if let scheduleTrackerEntity = scheduleTrackers.first {
        ////                context.delete(scheduleTrackerEntity)
        //            }
        //
        //            let originalTrackers = try context.fetch(originTrackerFetchRequest)
        //            if let tracker =  originalTrackers.first {
        //
        //                context.delete(tracker)
        //            }
        //        } catch {
        //            print(error.localizedDescription)
        //            throw  TrackerErrors.decodingError
        //        }
        let originalTrackers = try context.fetch(originTrackerFetchRequest)
        if let tracker =  originalTrackers.first {
            
            context.delete(tracker)
            try context.save()
            
        }
    }
    func trackerIsPinned(isPinned: Bool, tracker: Tracker) throws {
        let trackerEntity = try fetchTrackerEntity(for: tracker)
        trackerEntity.isPinned = isPinned
        try context.save()
    }
    
    func fetchTrackerEntity(for tracker: Tracker) throws -> TrackerEntity {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        let predicate = NSPredicate(format: "trackerId == %@", tracker.id as CVarArg)
        request.predicate = predicate
        guard let trackerEntity  = try context.fetch(request).first else {
            throw TrackerErrors.fetchError
        }
        return trackerEntity
    }
    
    //    func getPinnedCategory(tracker: Tracker) throws -> TrackerCategory {
    //        if let pinnedCategories = try getCategories().first(where: {$0.title == "Закрепленные"}) {
    //            return pinnedCategories
    //        } else {
    //            let pinnedCategory = TrackerCategory(title: "Закрепленные", trackers: [tracker])
    //            try addTrackerCategory(pinnedCategory)
    //            return pinnedCategory
    //        }
    //
    //    }
    func fetchCategoEntity(for category: TrackerCategory) throws -> TrackerCategoryEntity {
        let request: NSFetchRequest<TrackerCategoryEntity> = TrackerCategoryEntity.fetchRequest()
        let predicate = NSPredicate(format: "title == %@", category.title)
        request.predicate = predicate
        guard let categoryEntity = try context.fetch(request).first else {
            throw TrackerErrors.fetchError
        }
        return categoryEntity
    }
    
    func getCategories() throws -> [TrackerCategory] {
        let textPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryEntity.title), "Закрепленные")
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [textPredicate])
        
        let trackerCategory = fetchCategoriesWithPredicate(predicate)
        return trackerCategory
    }
    
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity])   -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        do {
            let trackersGroupedByTitle = Dictionary(grouping: trackersEntity) {$0.trackerCategory?.title}
            for (key, value) in trackersGroupedByTitle {
                let trackers = try value.map ({ try trackerStore.getTracker(from: ($0))})
                guard let key else {
                    return []
                }
                let trackerCategory = TrackerCategory(title: key, trackers: trackers)
                trackerCategories.append(trackerCategory)
            }
        } catch {
            print("Ошибка конвертации в котегорию")
        }
        return trackerCategories
    }
    
    func convertTrackerCategoryEntityToTrackerCategory(_ objects: [TrackerCategoryEntity]) throws -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        for object in objects {
            guard let title = object.title
                    
            else {
                throw TrackerErrors.decodingError
            }
            let trackersArray = try object.trackers?.compactMap({ $0 as? TrackerEntity}).compactMap({ try trackerStore.getTracker(from: ($0))
            }) ?? []
            let trackerCategory = TrackerCategory(title: title, trackers: trackersArray)
            trackerCategories.append(trackerCategory)
        }
        return trackerCategories
    }
    
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory] {
        guard let fetchRequest = trackerDataManager?.fetchRequest else { return [] }
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerEntity.title, ascending: true)
        ]
        fetchRequest.predicate = predicate
        
        do {
            try trackerDataManager?.performFetch()
            guard let trackersEntities = trackerDataManager?.fetchedObjects else { return [] }
            let trackerCategories =  convertTrackerCategoryEntityToTrackerCategories(trackersEntities)
            return trackerCategories
        } catch {
            return []
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoriesDidUpdate()
    }
}

