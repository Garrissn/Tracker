//
//  TrackerStore.swift
//  Tracker
//
//  Created by Игорь Полунин on 26.07.2023.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func deleteTracker(trackerEntity: TrackerEntity) throws
    func fetchTracker(id: String) -> TrackerEntity?
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker
    func updateTracker(trackerEntity: TrackerEntity, trackerCategoryEntity: TrackerCategoryEntity, trackerTitle: String) throws
    func addTracker(tracker: Tracker, trackerCategoryEntity: TrackerCategoryEntity) throws
}

enum TrackerErrors: Error {
    case noTrackerInCategory
    case decodingError
    case fetchError
}

final  class TrackerStore {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
    func addTracker(tracker: Tracker, trackerCategoryEntity: TrackerCategoryEntity) throws {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.trackerId = tracker.id.uuidString
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        let color = tracker.color
        let hexColor = uiColorMarshalling.hexString(from: color)
        trackerEntity.color = hexColor
        trackerEntity.isPinned = tracker.isPinned
        trackerEntity.selectedColorIndexPath = tracker.selectedColorIndexPath
        trackerEntity.selectedEmojiIndexPath = tracker.selectedEmojiIndexPath
        let scheduleString = tracker.schedule.map { $0.numberValue }
        trackerEntity.schedule = scheduleString.map(String.init).joined(separator: ", ")
        trackerEntity.trackerCategory = trackerCategoryEntity
        try context.save()
    }
    
    
    
    func getTracker(from trackerEntity: TrackerEntity) throws -> Tracker {
        let isPinned = trackerEntity.isPinned
        guard let selectedEmojiIndexPath = trackerEntity.selectedEmojiIndexPath,
              let selectedColorIndexPath = trackerEntity.selectedColorIndexPath,
              
                let id = trackerEntity.trackerId,
              let title = trackerEntity.title,
              let emoji = trackerEntity.emoji,
              let hexColor = trackerEntity.color,
              let scheduleSet = trackerEntity.schedule
        else {
            throw TrackerErrors.decodingError
        }
        
        let numbersArray = scheduleSet.components(separatedBy: ", ")
        let schedule: [WeekDay] = numbersArray.compactMap { numnerString in
            if let number = Int(numnerString) {
                return WeekDay.allCases.first { $0.numberValue == number }
            }
            return nil
        }
        
        let color = uiColorMarshalling.color(from: hexColor)
        guard let trackerUUID = UUID(uuidString: id) else { fatalError("Error with UUID") }
        let tracker = Tracker(isPinned: isPinned,
                              id: trackerUUID,
                              title: title,
                              color: color,
                              emoji: emoji,
                              schedule: schedule,
                              selectedEmojiIndexPath: selectedEmojiIndexPath,
                              selectedColorIndexPath: selectedColorIndexPath)
        return tracker
    }
    
    func deleteTracker(trackerEntity: TrackerEntity) throws {
        
        context.delete(trackerEntity)
        try context.save()
    }
    
    func updateTracker(trackerEntity: TrackerEntity, trackerCategoryEntity: TrackerCategoryEntity, trackerTitle: String) throws {
        trackerEntity.trackerCategory = trackerCategoryEntity
        try context.save()
    }
    
    func fetchTracker(id: String) -> TrackerEntity? {
        let request = NSFetchRequest<TrackerEntity>(entityName: "TrackerEntity")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerEntity.trackerId), id)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate])
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let trackers = try context.fetch(request).first
            if let firstTracker = trackers {
                return firstTracker
            } else {
                return nil
            }
        } catch {
            print("Ошибка при выполнении запроса: \(error.localizedDescription)")
            return nil
        }
    }
}
