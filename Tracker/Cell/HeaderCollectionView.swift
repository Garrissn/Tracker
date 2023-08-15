//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Игорь Полунин on 27.06.2023.
//

import UIKit

final class HeaderCollectionView: UICollectionReusableView {
    
    static let headerIdentifier = "HeaderIdentifier"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ypBold19()
        label.textColor = .TrackerBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
        ])
    }
    func configureHeader(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
