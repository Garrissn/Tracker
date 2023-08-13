//
//  SeparatoeLineHelper.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.08.2023.
//

import UIKit

final class SeparatorLineHelper {
    // Настройка отображения разделительной линии в таблице, в соответствии с макетами
    static func configSeparatingLine(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            // Если текущая ячейка последняя, скрываем разделительную линию
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            cell.selectionStyle = .none
        } else {
            // В остальных случаях показываем разделительную линию с нужными отступами
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
