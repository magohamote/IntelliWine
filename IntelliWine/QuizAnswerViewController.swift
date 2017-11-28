//
//  QuizAnswerViewController.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 21/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import UIKit

class QuizAnswerViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    var answerText: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        finishButton.addTarget(self, action: #selector(finish(_:)), for: .touchUpInside)
        finishButton.layer.cornerRadius = finishButton.frame.height/2
        
        if let answer = answerText {
            answerLabel.text = answer
        } else {
            answerLabel.text = "error"
        }
    }
    
    // MARK: - Button actions
    @objc func finish(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
