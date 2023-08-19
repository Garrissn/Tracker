//
//  DataManager.swift
//  Tracker
//
//  Created by Игорь Полунин on 27.06.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    var categories: [TrackerCategory] = [
    TrackerCategory(title: "Работа по дому",
                    trackers: [
                        Tracker(isPinned: false, id: UUID(),
                            title: "Полить цветы",
                            color: .ColorSelection5,
                            emoji: "🌺",
                            schedule: [WeekDay.monday,WeekDay.friday,WeekDay.thursday]),
                        Tracker(isPinned: false, id: UUID(),
                            title: "Помыть посуду",
                            color: .ColorSelection9,
                            emoji: "🔥",
                            schedule: [WeekDay.monday,WeekDay.wednesday,WeekDay.saturday,WeekDay.sunday])
                    ]),
    TrackerCategory(title: "Приятные привычки",
                    trackers: [
                        Tracker(isPinned: false, id: UUID(),
                            title: "Прогулка с собакой",
                            color: .ColorSelection1,
                            emoji: "🐶",
                            schedule: [WeekDay.monday,WeekDay.thursday])
                    ])
    
    
    ]
    
    private init() {}
}
