//
//  TabBarController.swift
//  Tracker
//
//  Created by Игорь Полунин on 09.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
       
        
        //let trackerRecordStore = TrackerRecordStore(context: <#T##NSManagedObjectContext#>)
         let statisticModel = StatisticModel(trackerRecordStore: trackerRecordStore)
         let statisticViewModel = StatisticViewModel(model: statisticModel)
        
        let statisticViewController = StatisticViewController(viewModel: statisticViewModel)
        
       
        
        let mainScreenNavigationController = UINavigationController(rootViewController: mainScreenViewController)
        let staticticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        self.viewControllers = [mainScreenNavigationController,staticticNavigationController]
        
        //настройка вкладок таббара
        mainScreenViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers.title", comment: "Title of the trackers item on the tab bar"),
            image: UIImage(named:"record.circle.fill"),
            tag: 0
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics.title", comment: "Title of the statistics item on the tab bar"),
            image: UIImage(named: "hare.fill"),
            tag: 1
        )
       
        
        tabBar.barTintColor = .Gray
        tabBar.backgroundColor = .TrackerWhite
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = UIColor.Gray
        tabBar.addSubview(lineView)
    }
}
