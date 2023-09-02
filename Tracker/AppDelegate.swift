//
//  AppDelegate.swift
//  Tracker
//
//  Created by Игорь Полунин on 21.06.2023.
//

import YandexMobileMetrica
import UIKit
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistantConteiner:NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "CoreDataModel")
        conteiner.loadPersistentStores { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return conteiner
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistantConteiner.viewContext
    }()
    

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AnaliticsService.shared.activate()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.storyboard = nil
        configuration.sceneClass = UIWindowScene.self
        configuration.delegateClass = SceneDelegate.self
        
        return configuration
    }
    
   
}

