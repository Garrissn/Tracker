//
//  AddNewCategoryModel.swift
//  Tracker
//
//  Created by Игорь Полунин on 11.08.2023.
//

import Foundation

final class AddNewCategoryModel {
    // выполняется проверка вводимого текста в поле название категории , название должно быть некороче одного символа
    private let requiredLength = 1
    
    func didEnter(categoryTitleText: String) -> Result<Bool, Error> {
        do {
            try checkTitleFor(text: categoryTitleText)
        } catch {
            return.failure(error)
        }
        let isTitleOk = checkIsTitleOk(for: categoryTitleText)
        return.success(isTitleOk)
    }
    
    private func checkTitleFor(text: String) throws {
        if text.count < requiredLength {
            throw NameFieldErrors.shortString
        }
    }
    
    private func checkIsTitleOk(for textFieldText: String) -> Bool {
        textFieldText.count >= requiredLength ? true : false
    }
}

enum NameFieldErrors: Error {
    case shortString
    
    var localizedDescription: String {
        switch self {
        case .shortString: return "Поле должно содержать не менее 1 символа!"
        }
    }
}
