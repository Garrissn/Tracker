//
//  AddCategoryModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.08.2023.
//


import UIKit

final class AddCategoryModel {
    //для загрузки категории из кротдаты и записи категории в кордату
   
    private lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistantConteiner.viewContext

        private lazy var trackerStore: TrackerStore = {
            return TrackerStore(context: context)
        }()
    
        private lazy var trackerCategoryStore: TrackerCategoryStore = {
            return TrackerCategoryStore(context: context, trackerStore: trackerStore)
        }()
        
        private lazy var trackerRecordStore: TrackerRecordStore = {
            return TrackerRecordStore(context: context)
        }()
        
        private lazy var trackerDataManager: TrackerDataManager = {
            return TrackerDataManager(trackerStore: trackerStore,
                                      trackerCategoryStore: trackerCategoryStore,
                                      trackerRecordStore: trackerRecordStore,
                                      context: context)
        }()
    
    
    func loadCategoriesFromCoreData() -> [Category] {
        return trackerDataManager.categories.compactMap {
            let title = $0.title
            return Category(title: title, isSelected: false)
        }
    }
    
    func addNewCategory(category: TrackerCategory) {
        try? trackerDataManager.addTrackerCategory(category)
    }
    
    func setupDelegate(vc: AddCategoryViewModel) {
        self.trackerCategoryStore.setDelegate(delegateForStore: vc)
    }
    
}

struct Category {
    let title: String
    var isSelected: Bool
}
