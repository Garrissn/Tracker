//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.06.2023.
//


import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "error3")
        imageView.image = image
        imageView.isHidden = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeHolderText: UILabel = {
        let label = UILabel ()
        label.text = NSLocalizedString(
            "placeholder.emptyStatistics.title",
            comment: "Title of the state with empty statistics")
        label.textColor = .BlackDay
        label.font = UIFont.ypMedium12()
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .WhiteDay
        addNavigationBar()
        addPlaceholderView()
    }
}

// MARK: - Add Subviews

private extension StatisticViewController {
    
    func addNavigationBar() {
        let localizedTitle = NSLocalizedString(
            "statistics.title",
            comment: "Title of the statistics in the navigation bar"
        )
        navigationItem.title = localizedTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addPlaceholderView() {
        view.addSubview(placeHolderImageView)
        view.addSubview(placeHolderText)
        
        NSLayoutConstraint.activate([
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeHolderText.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
