//
//  StaticticDataManager.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.08.2023.
//

import Foundation

final class StatisticModel {
    private let trackerDatamanager: TrackerDataManagerProtocol
    
    init(trackerDatamanager: TrackerDataManagerProtocol) {
        self.trackerDatamanager = trackerDatamanager
    }
    
    func getTrackersRecordCount() -> [TrackerRecord] {
        trackerDatamanager.getCompletedTrackers()
    }
}
