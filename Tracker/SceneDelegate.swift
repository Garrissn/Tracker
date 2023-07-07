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
        
        let tabBarController = UITabBarController()
        let mainScreenViewController = MainScreenTrackerViewController()
        
        let mainScreenNavigationController = UINavigationController(rootViewController: mainScreenViewController)
        
        let statisticViewController = StatisticViewController()

        tabBarController.viewControllers = [mainScreenNavigationController,statisticViewController]
        
        //настройка вкладок
        mainScreenViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named:"record.circle.fill"), tag: 0)

        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hare.fill"), tag: 1)
       
//        let tabBar = tabBarController.tabBar
      
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        
       
    }
}

