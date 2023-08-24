//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 24.08.2023.
//

import Foundation

final class StatisticViewModel {
    @Observable
    private (set) var allTimeTrackersCompleted: [TrackerRecord] = []
    
    private let model: StatisticModel
    
    init(model: StatisticModel) {
        self.model = model
    }
    
    func getAllCompletedTrackersCount() {
        let allTrackerRecords = model.getTrackersRecordCount()
        allTimeTrackersCompleted = allTrackerRecords
    }
}
