//
//  AddCategoryViewModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.08.2023.
//

import Foundation

final class AddCategoryViewModel {
    private let model: AddCategoryModel
    
    init(model: AddCategoryModel) {
        self.model = model
        model.trackerCategoryStore.onTrackerCategoryAdded = { [weak self] in
            self?.loadCategories()
        }
    }
    
    @Observable
    private (set) var categories: [Category] = []
    //вью через вьюмодельвью запрашивает категории из кордаты и записывает
    
    func loadCategories() {
        let allCategories = model.loadCategoriesFromCoreData()
        convertingData(with: allCategories)
        print(" категории загружены1")
    }
    
    func addNewCategory(category: TrackerCategory) {
        model.addNewCategory(category: category)
    }
    
    func selectedCategory(index: Int) {
        categories[index].isSelected = true
    }
    
    func convertingData(with categories: [Category]?) {
        if let categories = categories {
            for element in  categories {
                let category = Category(title: element.title, isSelected: element.isSelected)
                self.categories.append(category)
                print(" категории загружены2")
            }
        }
    }
}
extension AddCategoryViewModel: TrackerCategoryStoreDelegate {
    func categoriesDidUpdate() {
        categories.removeAll()
        loadCategories() 
    }
}

