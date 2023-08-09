//
//  TrackerCategoryStoreUpdate.swift
//  Tracker
//
//  Created by Игорь Полунин on 30.07.2023.
//

import Foundation

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
    let movedIndexes: [Move]
}
