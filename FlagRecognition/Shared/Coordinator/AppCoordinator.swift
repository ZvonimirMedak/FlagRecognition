//
//  AppCoordinator.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
import UIKit
class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var homeCoordinator: HomeCoordinator?
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        self.homeCoordinator = HomeCoordinator(navController: UINavigationController())
        window.rootViewController = homeCoordinator?.navigationController
        window.makeKeyAndVisible()
        
        guard let tabBarCoordinator = self.homeCoordinator else {return}
        self.addChildCoordinator(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        removeChildCoordinator(coordinator: self)
    }
}

