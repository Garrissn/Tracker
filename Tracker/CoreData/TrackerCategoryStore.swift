//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Игорь Полунин on 27.07.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreProtocol {
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?)
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity]) throws -> [TrackerCategory]
    func convertTrackerCategoryEntityToTrackerCategory(_ objects: [TrackerCategoryEntity]) throws -> [TrackerCategory]
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory]
}

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    private var trackerStore: TrackerStoreProtocol
    private weak var trackerDataController: NSFetchedResultsController<TrackerEntity>?
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStoreProtocol) {
        self.context = context
        self.trackerStore = trackerStore
    }
}
// MARK: - TrackerCategoryStoreProtocol

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?) {
        self.trackerDataController = controller
    }
    
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        guard let firstTracker = trackerCategory.trackers.first else {
            throw TrackerErrors.noTrackerInCategory
        }
        let trackerEntity =  trackerStore.convertTrackerToTrackerEntity(firstTracker)
        
        let request = NSFetchRequest<TrackerCategoryEntity>(entityName: "TrackerCategoryEntity")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryEntity.title), trackerCategory.title)
        
        let categories = try context.fetch(request)
        if let category = categories.first {
            category.addToTrackers(trackerEntity)
        } else {
            let newCategory = TrackerCategoryEntity(context: context)
            newCategory.title = trackerCategory.title
            newCategory.addToTrackers(trackerEntity)
        }
        try context.save()
    }
    
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity]) throws -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        
        let trackersGroupedByTitle = Dictionary(grouping: trackersEntity) {$0.trackerCategory?.title}
        for (key, value) in trackersGroupedByTitle {
            let trackers = try value.map ({ try trackerStore.convertTrackerEntityToTracker($0)})
            guard let key else {
                throw TrackerErrors.decodingError
            }
            let trackerCategory = TrackerCategory(title: key, trackers: trackers)
            trackerCategories.append(trackerCategory)
        }
        
        return trackerCategories
    }
    
    func convertTrackerCategoryEntityToTrackerCategory(_ objects: [TrackerCategoryEntity]) throws -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        for object in objects {
            guard let title = object.title else {
                throw TrackerErrors.decodingError
            }
            let trackersArray = try object.trackers?.compactMap({ $0 as? TrackerEntity}).compactMap({ try trackerStore.convertTrackerEntityToTracker($0)
            }) ?? []
            let trackerCategory = TrackerCategory(title: title, trackers: trackersArray)
            trackerCategories.append(trackerCategory)
        }
        return trackerCategories
    }
    
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory] {
        guard let fetchRequest = trackerDataController?.fetchRequest else { return [] }
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerEntity.title, ascending: true)
        ]
        fetchRequest.predicate = predicate
        
        do {
            try trackerDataController?.performFetch()
            guard let trackersEntities = trackerDataController?.fetchedObjects else { return [] }
            let trackerCategories = try convertTrackerCategoryEntityToTrackerCategories(trackersEntities)
            return trackerCategories
        } catch {
            return []
        }
    }
}



