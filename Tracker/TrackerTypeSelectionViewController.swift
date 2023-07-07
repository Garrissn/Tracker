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

final class TrackerTypeSelectionViewController: UIViewController {
    
    private lazy var habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.setTitle("Привычка", for: .normal)
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
        irregularIventButton.setTitle("Не регулярное событие", for: .normal)
        irregularIventButton.setTitleColor(.WhiteDay, for: .normal)
        irregularIventButton.backgroundColor = .BlackDay
        irregularIventButton.clipsToBounds = true
        irregularIventButton.titleLabel?.font = UIFont.ypMedium16()
        irregularIventButton.layer.cornerRadius = 16
        irregularIventButton.addTarget(self, action: #selector(irregularIventButtonTapped), for: .touchUpInside)
        return irregularIventButton
    }()
    
    weak var delegate: TrackerTypeSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .WhiteDay
        setupLayoutViews()
        setupNavigationBar()
    }
    private func  setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Создание трекера"
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
            //habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
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

extension TrackerTypeSelectionViewController: AddNewTrackerViewControllerDelegate {
    func didSelectNewTracker(newTracker: TrackerCategory) {
        self.delegate?.didselectNewTracker(newTracker: newTracker)
        let mainScreenViewController = MainScreenTrackerViewController()
        //let navVC = UINavigationController(rootViewController: mainScreenViewController)
       // present(navVC, animated: true)
        dismiss(animated: true)
        
    }
    
    
}
