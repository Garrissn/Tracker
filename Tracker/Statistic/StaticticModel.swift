//
//  StaticticDataManager.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.08.2023.
//

import Foundation

final class StatisticModel {
    private let trackerRecordStore: TrackerRecordStoreProtocol
    
    init(trackerRecordStore: TrackerRecordStoreProtocol) {
        self.trackerRecordStore = trackerRecordStore
    }
    
    func getTrackersRecordCount() -> [TrackerRecord] {
        trackerRecordStore.getCompletedTrackers()
    }
}
