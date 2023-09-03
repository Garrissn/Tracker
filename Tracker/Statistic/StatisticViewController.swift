//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.06.2023.
//


import UIKit

final class StatisticViewController: UIViewController {
    
    private let viewModel: StatisticViewModel
    
    // MARK: - Properties
    
    private lazy var placeHolderImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "error3")
        imageView.image = image
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeHolderText: UILabel = {
        let label = UILabel ()
        label.text = NSLocalizedString(
            "placeholder.emptyStatistics.title",
            comment: "Title of the state with empty statistics")
        label.textColor = .TrackerBlack
        label.font = UIFont.ypMedium12()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    
    private let statisticCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: StatisticCollectionViewCell.StatisticCollectionViewCellIdentifier)
        
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .TrackerWhite
        addNavigationBar()
        addPlaceholderView()
        configCollectionView()
        statisticCollectionView.dataSource = self
        statisticCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllCompletedTrackersCount()
        checkPlaceHolder()
    }
    
    private func bind() {
        viewModel.$allTimeTrackersCompleted.bind { [weak self] _ in
            guard let self = self else { return }
            self.statisticCollectionView.reloadData()
        }
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
        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.TrackerBlack]
    }
    
    func addPlaceholderView() {
        view.addSubview(statisticCollectionView)
        view.addSubview(placeHolderImageView)
        view.addSubview(placeHolderText)
        
        NSLayoutConstraint.activate([

            statisticCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            statisticCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -126),
            
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeHolderText.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configCollectionView() {
        
    }
    
    private func checkPlaceHolder() {
        if viewModel.allTimeTrackersCompleted.count > 0 {
            placeHolderImageView.isHidden = true
            placeHolderText.isHidden = true
            statisticCollectionView.isHidden = false
        } else {
            placeHolderImageView.isHidden = false
            placeHolderText.isHidden = false
            statisticCollectionView.isHidden = true
        }
    }
}

extension StatisticViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticCollectionViewCell.StatisticCollectionViewCellIdentifier, for: indexPath) as? StatisticCollectionViewCell else { return UICollectionViewCell() }
        let trackersCount = viewModel.allTimeTrackersCompleted.count
        let cellName = "Трекеров завершено"
        cell.configureStatisticCell(countLabel: String(trackersCount), descriptionLabel: cellName)
        return cell
    }
}


extension StatisticViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 32, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}
