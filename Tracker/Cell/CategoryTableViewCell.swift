//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 10.08.2023.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let categoryTableViewCellIdentifier = "CategoryTableViewCellIdentifier"
    
    private lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .BlackDay
        label.font = UIFont.ypRegular17()
        return label
    }()
    
    private lazy var doneImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .BackGroundDay
        setupViews()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func   setupViews() {
        contentView.addSubview(cellTitleLabel)
        contentView.addSubview(doneImageView)
    }
    
    private func   setupConstraints() {
        
        NSLayoutConstraint.activate([
            cellTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            doneImageView.centerYAnchor.constraint(equalTo: cellTitleLabel.centerYAnchor),
            doneImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
