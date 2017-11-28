//
//  UILabel+Height.swift
//  IntelliWine
//
//  Created by Rolland Cédric on 27.11.17.
//  Copyright © 2017 IntelliWine. All rights reserved.
//

import UIKit

extension UILabel {
    func retrieveTextHeight () -> CGFloat {
        guard let text = self.text else {
            return 0
        }
        
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
}
