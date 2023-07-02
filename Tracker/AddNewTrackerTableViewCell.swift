//
//  AddNewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.06.2023.
//

import UIKit

final class AddNewTrackerTableViewCell: UITableViewCell {
    
    private let categoryLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .BlackDay
        return label
    }()
    
//    private let scheduleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.cornerRadius = 16
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textColor = .BlackDay
//        return label
//    }()
    private let iconImageView: UIImageView = {
            let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.image = UIImage(named: "ItableViewIcon.fill")
                return imageView
       }()
    
    //weak var delegate: AddNewTrackerTableViewCellDelegate
    static let reuseIdentifier = "tableViewCellIdentifier"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableViewCell() {
       
        contentView.addSubview(iconImageView)
        contentView.addSubview(categoryLabel)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .BackGroundDay
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 271),
            
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
            
            
        ])
        
    }
    
   
}
