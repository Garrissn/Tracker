//
//  AddNewTrackerColorViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 02.08.2023.
//


import UIKit

final class AddNewTrackerColorViewCell: UICollectionViewCell {
    
    static let addNewTrackerColorViewCellIdentifier = "AddNewTrackerColorViewCellIdentifier"
    
    let colorViewBack: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let colorViewFront: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedColor (forColor: UIColor?) {
        colorViewBack.layer.borderWidth = 3
        colorViewBack.layer.borderColor = forColor?.withAlphaComponent(0.3).cgColor
    }
    
    func deselectedColor() {
        colorViewBack.backgroundColor = .clear
        colorViewBack.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func addViews() {
        contentView.addSubview(colorViewBack)
        colorViewBack.addSubview(colorViewFront)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorViewBack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorViewBack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorViewBack.heightAnchor.constraint(equalToConstant: 52),
            colorViewBack.widthAnchor.constraint(equalToConstant: 52),
            
            colorViewFront.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorViewFront.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorViewFront.topAnchor.constraint(equalTo: colorViewBack.topAnchor, constant: 6),
            colorViewFront.leadingAnchor.constraint(equalTo: colorViewBack.leadingAnchor, constant: 6),
            colorViewFront.heightAnchor.constraint(equalToConstant: 40),
            colorViewFront.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
