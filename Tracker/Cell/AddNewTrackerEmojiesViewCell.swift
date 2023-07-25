//
//  AddNewTrackerViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 13.07.2023.
//

import UIKit


final class AddNewTrackerEmojiesViewCell: UICollectionViewCell {
    
    static let addNewTrackerEmojiesViewCellIdentifier = "AddNewTrackerEmojiesViewCellIdentifier"
    
     let emojiView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     var emojiLabel: UILabel = {
        let label = UILabel()
         label.textAlignment = .center
         label.font = UIFont.ypBold32()
         label.layer.masksToBounds = true
         label.layer.cornerRadius = 8
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAddNewTrackerEmojiesViewCell(with emoji: String) {
        emojiLabel.text = emoji
        
    }
    
    private func addViews() {
        contentView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
    }
    
    private func setupConstraints() {
      NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiView.heightAnchor.constraint(equalToConstant: 52),
            emojiView.widthAnchor.constraint(equalToConstant: 52),
            
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
           emojiLabel.topAnchor.constraint(equalTo: emojiView.topAnchor, constant: 6),
            emojiLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor, constant: 6),
            emojiLabel.heightAnchor.constraint(equalToConstant: 40),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
