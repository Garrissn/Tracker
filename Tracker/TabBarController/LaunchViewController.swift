//
//  LaunchViewController.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.08.2023.
//

import UIKit

final class LaunchViewController: UIViewController {
    @UserDefaultsBacked<Bool>(key: "is onboarding completed") private var isOnboardingCompleted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        let mainTabbarController = TabBarController()
        guard isOnboardingCompleted != nil else {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.confirmedByUser = { [weak self] in
                guard let self = self else { return }
                
                self.isOnboardingCompleted = true
                self.removeViewController(chieldViewController: onboardingViewController)
                self.addViewController(chieldViewController: mainTabbarController)
            }
            addViewController(chieldViewController: onboardingViewController)
            return
        }
        addViewController(chieldViewController: mainTabbarController)
    }
    
    private func addViewController(chieldViewController: UIViewController) {
        if let chieldView = chieldViewController.view,
           let parentView = view {
            addChild(chieldViewController)
            parentView.addSubview(chieldView)
            chieldView.translatesAutoresizingMaskIntoConstraints = false 
            
            NSLayoutConstraint.activate([
                chieldView.topAnchor.constraint(equalTo: parentView.topAnchor),
                chieldView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                chieldView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                chieldView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
            ])
        }
        chieldViewController.didMove(toParent: self)
    }
    
    private func removeViewController(chieldViewController: UIViewController) {
        chieldViewController.willMove(toParent: nil)
        chieldViewController.view.removeFromSuperview()
        chieldViewController.removeFromParent()
    }
}
