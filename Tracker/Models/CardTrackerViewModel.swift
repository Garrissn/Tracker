//
//  CardTrackerViewModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 31.07.2023.
//

import Foundation

struct CardTrackerViewModel {
    let tracker: Tracker
    let isCompletedToday: Bool
    let completedDays: Int
    let indexPath: IndexPath
    let currentDate: Date
}
