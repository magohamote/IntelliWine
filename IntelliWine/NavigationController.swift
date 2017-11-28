//
//  NavigationController.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 28.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = myColor.purple
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)
        ]
    }
}
