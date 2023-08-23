//
//  StaticticTableViewCell.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.08.2023.
//

import UIKit

final class StatisticCollectionViewCell: UICollectionViewCell {
    static let StatisticCollectionViewCellIdentifier = "StatisticCollectionViewCellIdentifier"
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var statInView: UIView = {
        let view = UIView()
        view.backgroundColor = .TrackerWhite
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
     lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TrackerBlack
        label.font = UIFont.ypBold34()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
     lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .TrackerBlack
        label.font = UIFont.ypMedium12()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.ColorSelection1.cgColor, UIColor.ColorSelection9.cgColor, UIColor.ColorSelection3.cgColor]
            gradientLayer.locations = [0, 0.5, 1]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            return gradientLayer
        }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
        gradientView.layoutIfNeeded() // Добавьте эту строку
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        gradientLayer.frame = gradientView.bounds
        gradientView.layoutIfNeeded() // Добавьте эту строку
      //  setupGradient()
        layer.cornerRadius = 16
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    private func setupViews() {
        contentView.addSubview(gradientView)
        
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.layer.cornerRadius = 16
        gradientView.addSubview(statInView)
      
        statInView.addSubview(countLabel)
        statInView.addSubview(descriptionLabel)
    }
    private func configCell() {
        contentView.layer.cornerRadius = 16
        self.backgroundColor = .TrackerWhite
   
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            statInView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 1),
            statInView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 1),
            statInView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -1),
            statInView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -1),
            
            
            countLabel.topAnchor.constraint(equalTo: statInView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: statInView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: statInView.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: statInView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: statInView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: statInView.bottomAnchor, constant: -12),
            
        ])
    }
    
    func configureStatisticCell(countLabel: String , descriptionLabel: String) {
        self.countLabel.text = countLabel
        self.descriptionLabel.text = descriptionLabel
    }
}
