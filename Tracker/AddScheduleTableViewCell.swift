//
//  AddScheduleTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 01.07.2023.
//

import UIKit

final class AddScheduleTableViewCell: UITableViewCell {
    
    
     let schDaysLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         
        label.layer.cornerRadius = 16
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .BlackDay
        return label
        
    }()
    
     let daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = .Blue
         daySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        
        return daySwitch
    }()
    
    static let reuseIdentifier = "addScheduleTableViewCellIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableViewCell() {
        contentView.addSubview(schDaysLabel)
        contentView.addSubview(daySwitch)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.backgroundColor = .BackGroundDay
        
        NSLayoutConstraint.activate([
            schDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            schDaysLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.5),
            schDaysLabel.heightAnchor.constraint(equalToConstant: 22),
            schDaysLabel.widthAnchor.constraint(equalToConstant: 244),
            
            daySwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.heightAnchor.constraint(equalToConstant: 31),
            daySwitch.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
    
}
