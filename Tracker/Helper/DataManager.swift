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
                    Tracker(id: UUID(),
                            title: "Полить цветы",
                            color: .ColorSelection5,
                            emoji: "🌺",
                            schedule: [WeekDay.tuesday,WeekDay.friday]),
                    Tracker(id: UUID(),
                            title: "Помыть посуду",
                            color: .ColorSelection9,
                            emoji: "🌺",
                            schedule: [WeekDay.monday,WeekDay.tuesday,WeekDay.friday])
                    ]),
    TrackerCategory(title: "Приятные привычки",
                    trackers: [
                    Tracker(id: UUID(),
                            title: "Прогулка с собакой",
                            color: .ColorSelection1,
                            emoji: "🐶",
                            schedule: [WeekDay.monday])
                    ])
    
    
    ]
    
    private init() {}
}
