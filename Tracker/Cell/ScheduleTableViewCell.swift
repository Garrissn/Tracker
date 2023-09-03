//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 13.08.2023.
//

import UIKit
final class ScheduleTableViewCell: UITableViewCell {
    
    static let ScheduleTableViewCellIdentifier = "ScheduleTableViewCellIdentifier"
    
    private  var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TrackerBlack
        label.font = UIFont.ypRegular17()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .TrackerBackGround
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func   setupViews() {
        contentView.addSubview(cellTitleLabel)
        
    }
    
    private func   setupConstraints() {
        NSLayoutConstraint.activate([
            cellTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func configureScheduleTableCell(cellTitle: String) {
        self.cellTitleLabel.text = cellTitle
    }
}


