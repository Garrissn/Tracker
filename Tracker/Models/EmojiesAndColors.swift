//
//  EmojiesAndColors.swift
//  Tracker
//
//  Created by Игорь Полунин on 14.07.2023.
//

import UIKit

struct EmojiesAndColors {
    let emojiesTitle: String = "Emoji"
    let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colorTitle: String = "Цвет"
    let colors: [UIColor] = (1...18).map { UIColor(named: "ColorSelection\($0)") }.compactMap { $0 }
}

