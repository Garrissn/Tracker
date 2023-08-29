//
//  TrackerStore.swift
//  Tracker
//
//  Created by Игорь Полунин on 26.07.2023.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func convertTrackerEntityToTracker(_ object: TrackerEntity) throws -> Tracker
    func convertTrackerToTrackerEntity(_ tracker: Tracker) -> TrackerEntity
    func deleteTracker(trackerEntity: TrackerEntity) throws
    func fetchTracker(id: String) -> TrackerEntity?
    func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet
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
    
    private func convertScheduleEntityToArray(_ scheduleSet: NSSet) -> [WeekDay] {
        var scheduleArray: [WeekDay] = []
        for element in scheduleSet {
            guard let scheduleEntity = element as? ScheduleEntity,
                  let dayString = scheduleEntity.weekDay,
                  let day = WeekDay(rawValue: dayString) else { return [] }
            scheduleArray.append(day)
        }
        return scheduleArray
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
        
        let schedule = tracker.schedule
        trackerEntity.schedule = convertScheduleArrayToScheduleEntity(schedule)
        trackerEntity.trackerCategory = trackerCategoryEntity
    }
    
    
    
    func convertTrackerEntityToTracker(_ object: TrackerEntity) throws -> Tracker {
        let isPinned = object.isPinned
        guard let selectedEmojiIndexPath = object.selectedEmojiIndexPath,
              let selectedColorIndexPath = object.selectedColorIndexPath,
              
                let id = object.trackerId,
              let title = object.title,
              let emoji = object.emoji,
              let hexColor = object.color,
              let scheduleSet = object.schedule
        else {
            throw TrackerErrors.decodingError
        }
        let schedule = convertScheduleEntityToArray(scheduleSet)
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
    
    func convertTrackerToTrackerEntity(_ tracker: Tracker) -> TrackerEntity {
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
        
        let schedule = tracker.schedule
        trackerEntity.schedule = convertScheduleArrayToScheduleEntity(schedule)
        
        return trackerEntity
    }
    
    func deleteTracker(trackerEntity: TrackerEntity) throws {
        
        context.delete(trackerEntity)
        try context.save()
    }
    
    func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet {
        var scheduleEntitySet: Set<ScheduleEntity> = []
        for day in weekDays {
            let scheduleEntity = ScheduleEntity(context: context)
            scheduleEntity.weekDay = day.rawValue
            scheduleEntitySet.insert(scheduleEntity)
        }
        return NSSet(set: scheduleEntitySet)
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
