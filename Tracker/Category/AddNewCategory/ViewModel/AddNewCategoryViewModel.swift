//
//  AddNewCategoryViewModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 11.08.2023.
//

import Foundation

final class AddNewCategoryViewModel {
    private let model: AddNewCategoryModel
    
    @Observable
    private (set) var isCategoryTitleFilled = false
    init(model: AddNewCategoryModel) {
        self.model = model
    }
    
    //будет происходить проверка по запросу от вью заполнен ли тайтл категории и можно ли активировать кнопку
    func checkCategoryTitle(text: String?) {
        guard let text = text else { return }
        let result = model.didEnter(categoryTitleText: text)
        switch result {
        case.success(let result):
            isCategoryTitleFilled = result
            print("созо")
        case.failure(let error):
            isCategoryTitleFilled = false
            print(error.localizedDescription)
        }
    }
}
