//
//  PlaceholderView.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.06.2023.
//

import UIKit

final class PlaceholderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SP-Pro", size: 20)
        label.textColor = .gray
        label.text = "Что будем отслеживать"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "error")
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        addSubview(errorImage)
        addSubview(titleLabel)
        
    }
    private func setupConstrains() {
        
        NSLayoutConstraint.activate([
            
            errorImage.heightAnchor.constraint(equalToConstant: 80),
            errorImage.widthAnchor.constraint(equalToConstant: 80),
            errorImage.topAnchor.constraint(equalTo: topAnchor),
            errorImage.leadingAnchor.constraint(equalTo: leadingAnchor),



           titleLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])
        
    }
}
