//
//  UIViewController+Extension.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "An error occured", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

