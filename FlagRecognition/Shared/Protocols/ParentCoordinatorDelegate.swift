//
//  ParentCoordinatorDelegate.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
protocol ParentCoordinatorDelegate: class {
    func childHasFinished(coordinator: Coordinator)
}
