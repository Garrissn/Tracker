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
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?)
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity]) throws -> [TrackerCategory]
    func convertTrackerCategoryEntityToTrackerCategory(_ objects: [TrackerCategoryEntity]) throws -> [TrackerCategory]
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory]
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
//    func setDelegate(delegateForStore: TrackerCategoryStoreDelegate) {
//        delegate = delegateForStore
//    }
}
// MARK: - TrackerCategoryStoreProtocol

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerEntity>?) {
        self.trackerDataManager = controller
    }
    
    func addTrackerCategoryTitle(_ trackerCategory: TrackerCategory) throws {
        let newCategory = TrackerCategoryEntity(context: context)
        newCategory.title = trackerCategory.title
        try context.save()
        onTrackerCategoryAdded?()
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
    
    
    
    func convertTrackerCategoryEntityToTrackerCategories(_ trackersEntity: [TrackerEntity])   -> [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        do {
            let trackersGroupedByTitle = Dictionary(grouping: trackersEntity) {$0.trackerCategory?.title}
            for (key, value) in trackersGroupedByTitle {
                let trackers = try value.map ({ try trackerStore.convertTrackerEntityToTracker($0)})
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
            let trackersArray = try object.trackers?.compactMap({ $0 as? TrackerEntity}).compactMap({ try trackerStore.convertTrackerEntityToTracker($0)
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

