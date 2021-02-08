//
//  HomeCoordinator.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
import UIKit
class HomeCoordinator: NSObject, Coordinator{
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var controller: HomeViewController!
    weak var parentDelegate: ParentCoordinatorDelegate?
    init(navController: UINavigationController){
        navigationController = navController
        super.init()
        controller = createHomeViewController()
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func createHomeViewController() -> HomeViewController{
        let controller = HomeViewController()
        return controller
    }
}
