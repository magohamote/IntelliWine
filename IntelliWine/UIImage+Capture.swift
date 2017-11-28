//
//  UIImage.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 09/11/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    func capture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
