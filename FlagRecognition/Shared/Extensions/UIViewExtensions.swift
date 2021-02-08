//
//  UIViewExtension.swift
//  FlagRecognition
//
//  Created by Zvonimir Medak on 04.02.2021..
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
