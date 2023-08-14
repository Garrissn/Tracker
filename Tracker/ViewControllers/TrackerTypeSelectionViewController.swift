//
//  File.swift
//  Tracker
//
//  Created by Игорь Полунин on 23.06.2023.
//


import UIKit
protocol TrackerTypeSelectionViewControllerDelegate: AnyObject {
    func didselectNewTracker(newTracker: TrackerCategory)
}
private enum TrackerTypeSelectionLocalize {
    static let habitButtonText = NSLocalizedString("button.regularEvent.title", comment: "Title of the button on habitSelection")
    static let irregularEventButtonText = NSLocalizedString("button.irregularEvent.title", comment: "Title of the button on irregularSelection")
    static let createTrackerLabel = NSLocalizedString("newTracker.title", comment: "Title createTracker on navigationbar")
}

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.setTitle(TrackerTypeSelectionLocalize.habitButtonText, for: .normal)
        habitButton.setTitleColor(.WhiteDay, for: .normal)
        habitButton.backgroundColor = .BlackDay
        habitButton.clipsToBounds = true
        habitButton.titleLabel?.font = UIFont.ypMedium16()
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        return habitButton
    }()
    
    private lazy var irregularIventButton: UIButton = {
        let irregularIventButton = UIButton()
        irregularIventButton.translatesAutoresizingMaskIntoConstraints = false
        irregularIventButton.setTitle(TrackerTypeSelectionLocalize.irregularEventButtonText, for: .normal)
        irregularIventButton.setTitleColor(.WhiteDay, for: .normal)
        irregularIventButton.backgroundColor = .BlackDay
        irregularIventButton.clipsToBounds = true
        irregularIventButton.titleLabel?.font = UIFont.ypMedium16()
        irregularIventButton.layer.cornerRadius = 16
        irregularIventButton.addTarget(self, action: #selector(irregularIventButtonTapped), for: .touchUpInside)
        return irregularIventButton
    }()
    
    weak var delegate: TrackerTypeSelectionViewControllerDelegate?
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .WhiteDay
        setupLayoutViews()
        setupNavigationBar()
    }
    // MARK: - Private Methods
    
    private func  setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = TrackerTypeSelectionLocalize.createTrackerLabel
        titleLabel.textColor = .BlackDay
        titleLabel.font = UIFont.ypMedium16()
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    private func setupLayoutViews() {
        
        view.addSubview(habitButton)
        view.addSubview(irregularIventButton)
        
        NSLayoutConstraint.activate([
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.widthAnchor.constraint(equalToConstant: 335)
        ])
        NSLayoutConstraint.activate([
            irregularIventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            irregularIventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularIventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularIventButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    @objc private func habbitButtonTapped() {
        
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.trackerType = .habitTracker
        addNewTrackerViewController.delegate = self
        present(addNewTrackerViewController, animated: true)
        
    }
    @objc private func irregularIventButtonTapped() {
        
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.trackerType = .irregularIvent
        addNewTrackerViewController.delegate = self
        present(addNewTrackerViewController, animated: true)
        
    }
}

// MARK: - AddNewTrackerViewControllerDelegate

extension TrackerTypeSelectionViewController: AddNewTrackerViewControllerDelegate {
    func didSelectNewTracker(newTracker: TrackerCategory) {
        self.delegate?.didselectNewTracker(newTracker: newTracker)
       // let mainScreenViewController = MainScreenTrackerViewController()
        dismiss(animated: true)
    }
}
