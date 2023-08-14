//
//  AddNewTrackerTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 13.08.2023.
//

import UIKit

final class AddNewTrackerTableViewCell: UITableViewCell {
    static let AddNewTrackerTableViewCellIdentifier = "AddNewTrackerTableViewCellIdentifier"
    
    private  var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .BlackDay
        label.font = UIFont.ypRegular17()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  var destriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .BlackDay
        label.font = UIFont.ypRegular17()
        label.textColor = .Gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .BackGroundDay
        setupViews()
        configCell()
    }
    
    private func configCell() {
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.detailTextLabel?.font = UIFont.ypRegular17()
        self.detailTextLabel?.textColor = .Gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func   setupViews() {
        cellStackView.addArrangedSubview(cellTitleLabel)
        cellStackView.addArrangedSubview(destriptionTitleLabel)
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configureTableViewCellForCategory(cellTitle: String, detailTextLabelText: String) {
        self.cellTitleLabel.text = cellTitle
        self.destriptionTitleLabel.text = detailTextLabelText
    }
    func configureTableViewCellForSchedule(cellTitle: String, shcedule: [WeekDay]) {
        self.cellTitleLabel.text = cellTitle
        if shcedule.count == 7 {
            let localizedEveryDayTitle = NSLocalizedString(
                "everyDay",
                comment: "Title everyday when alldays are picked"
            )
            self.destriptionTitleLabel.text = localizedEveryDayTitle
        } else {
            let scheduleShortValueText = shcedule.map { $0.shortValue }.joined(separator: ",")
            self.destriptionTitleLabel.text = scheduleShortValueText
        }
    }
}
