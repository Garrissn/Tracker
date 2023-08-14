//
//  EmojiesAndColors.swift
//  Tracker
//
//  Created by Игорь Полунин on 14.07.2023.
//

import UIKit

private enum EmojiesColorsLocalize {
    static let localizedEmojiTitle = NSLocalizedString(
        "emoji.title",
        comment: "Emoji title on header collectionView"
    )
    static let localizedColorTitle = NSLocalizedString(
        "color.title",
        comment: "Color title on header collectionView"
    )
    
}

struct EmojiesAndColors {
    
    let emojiesTitle: String = EmojiesColorsLocalize.localizedEmojiTitle
    let emojies: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colorTitle: String = EmojiesColorsLocalize.localizedColorTitle
    let colors: [UIColor] = (1...18).map { UIColor(named: "ColorSelection\($0)") }.compactMap { $0 }
}

