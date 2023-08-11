//
//  AddCategoryModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.08.2023.
//


import UIKit

final class AddCategoryModel {
    init() {
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let trackerStore = TrackerStore(context: context)
            let categoryStore = TrackerCategoryStore(context: context, trackerStore: trackerStore)
        }
    
   
    
    func loadCategoriesFromCoreData() -> [Category] {
        
    }
}
