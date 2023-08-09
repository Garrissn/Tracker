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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistantConteiner.viewContext
        let trackerStore = TrackerStore(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context,
                                                        trackerStore: trackerStore)
        let trackerRecordStore = TrackerRecordStore(context: context)
        let trackerDataManager = TrackerDataManager(trackerStore: trackerStore,
                                                    trackerCategoryStore: trackerCategoryStore,
                                                    trackerRecordStore: trackerRecordStore,
                                                    context: context)
        trackerCategoryStore.setTrackerDataController(trackerDataManager.fetchResultController)
        let mainScreenViewController = MainScreenTrackerViewController(trackerDataManager: trackerDataManager)
        
        let mainScreenNavigationController = UINavigationController(rootViewController: mainScreenViewController)
        
        let statisticViewController = StatisticViewController()

        tabBarController.viewControllers = [mainScreenNavigationController,statisticViewController]
        
        //настройка вкладок таббара
        mainScreenViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named:"record.circle.fill"), tag: 0)
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hare.fill"), tag: 1)
       
       let tabBar = tabBarController.tabBar
        tabBar.barTintColor = .Gray
        tabBar.backgroundColor = .WhiteDay
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor.Gray
        tabBar.insertSubview(lineView, at: 0)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        
       
    }
}

