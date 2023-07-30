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
    
    private func convertScheduleArrayToScheduleEntity(_ weekDays: [WeekDay]) -> NSSet {
        var scheduleEntitySet: Set<ScheduleEntity> = []
        for day in weekDays {
            let scheduleEntity = ScheduleEntity(context: context)
            scheduleEntity.weekDay = day.rawValue
            scheduleEntitySet.insert(scheduleEntity)
        }
        return NSSet(set: scheduleEntitySet)
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    func convertTrackerEntityToTracker(_ object: TrackerEntity) throws -> Tracker {
        guard let id = object.id,
              let title = object.title,
              let emoji = object.emoji,
              let hexColor = object.color,
              let scheduleSet = object.schedule
        else {
            throw TrackerErrors.decodingError
        }
        let schedule = convertScheduleEntityToArray(scheduleSet)
        let color = uiColorMarshalling.color(from: hexColor)
        
        let tracker = Tracker(id: id,
                              title: title,
                              color: color,
                              emoji: emoji,
                              schedule: schedule)
        return tracker
    }
    
    func convertTrackerToTrackerEntity(_ tracker: Tracker) -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.emoji = tracker.emoji
        let color = tracker.color
        let hexColor = uiColorMarshalling.hexString(from: color)
        trackerEntity.color = hexColor
        
        if let schedule = tracker.schedule {
            trackerEntity.schedule = convertScheduleArrayToScheduleEntity(schedule)
        }
        return trackerEntity
    }
}
