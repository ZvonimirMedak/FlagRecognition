//
//  Coordinator.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
import UIKit
protocol Coordinator: class{
    var childCoordinators: [Coordinator] {get set}
    
    func start()
}

extension Coordinator{
    func addChildCoordinator(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator){
        childCoordinators = childCoordinators.filter{ $0 !== coordinator}
    }
}
