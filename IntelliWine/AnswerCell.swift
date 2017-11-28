//
//  QuestionCell.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 19/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import Foundation
import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerCheckbox: UIImageView!
    @IBOutlet weak var uilabelBackgroundView: UIView!
    @IBOutlet weak var uilabelBackgroundViewHeightConstraint: NSLayoutConstraint!
    
    var isActive = false
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func config(withAnswer answer: Answer) {
        uilabelBackgroundView.backgroundColor = .white
        backgroundColor = myColor.lightGray

        uilabelBackgroundView.layer.cornerRadius = 5

        answerCheckbox.tintColor = myColor.purple
        answerCheckbox.image = UIImage(named: "checkbox_empty")?.withRenderingMode(.alwaysTemplate)
        answerCheckbox.layer.cornerRadius = 5
        
        answerLabel.text = answer.answer
        uilabelBackgroundViewHeightConstraint.constant = answerLabel.retrieveTextHeight() + 20

        answerImage.layer.cornerRadius = 5
        answerImage.layer.borderWidth = 1
        answerImage.layer.borderColor = myColor.purple.cgColor
        answerImage.layer.masksToBounds = true
        answerImage.image = UIImage(named: "\(Int(arc4random_uniform(25)) + 1)") // select icons randomly
    }
}
