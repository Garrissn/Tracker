//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Игорь Полунин on 21.06.2023.
//


@testable import Tracker

import SnapshotTesting
import XCTest

class MyViewControllerTests: XCTestCase {
  func testMyTrackersViewControllerLightSnapshot() {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistantConteiner.viewContext
      let trackerStore = TrackerStore(context: context)
      let trackerCategoryStore = TrackerCategoryStore(context: context,
                                                      trackerStore: trackerStore)
      let trackerRecordStore = TrackerRecordStore(context: context)
      let trackerDataManager = TrackerDataManager(trackerStore: trackerStore,
                                                  trackerCategoryStore: trackerCategoryStore,
                                                  trackerRecordStore: trackerRecordStore,
                                                  context: context)
      trackerCategoryStore.setTrackerDataController(trackerDataManager.fetchResultController)
      
      let vc = MainScreenTrackerViewController(trackerDataManager: trackerDataManager)

      assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
  }
    
    func testMyTrackersViewControllerDarkSnapshot() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantConteiner.viewContext
        let trackerStore = TrackerStore(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context,
                                                        trackerStore: trackerStore)
        let trackerRecordStore = TrackerRecordStore(context: context)
        let trackerDataManager = TrackerDataManager(trackerStore: trackerStore,
                                                    trackerCategoryStore: trackerCategoryStore,
                                                    trackerRecordStore: trackerRecordStore,
                                                    context: context)
        trackerCategoryStore.setTrackerDataController(trackerDataManager.fetchResultController)
        
        let vc = MainScreenTrackerViewController(trackerDataManager: trackerDataManager)

        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
