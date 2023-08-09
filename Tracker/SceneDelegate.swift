//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Игорь Полунин on 21.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
//        if self.window?.rootViewController == nil {
//                let onboardingViewController = OnboardingViewController()
//                window.rootViewController = onboardingViewController
//                self.window = window
//                window.makeKeyAndVisible()
//            }
        
        let tbVC = TabBarController()
        let onboardingViewController = OnboardingViewController()
       
        window.rootViewController = onboardingViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

