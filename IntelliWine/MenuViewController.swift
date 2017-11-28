//
//  ViewController.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 08/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var startQuizzButton: UIButton!
    
    internal var questionsArray = [Question]()
    private var userVector: UserVector?
    private let questionDataSource = QuestionDataModel()
    private let userVectorDataSource = UserVectorDataModel()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        questionDataSource.delegate = self
        userVectorDataSource.delegate = self
        
        startQuizzButton.isEnabled = false
        startQuizzButton.addTarget(self, action: #selector(MenuViewController.startQuiz(_:)), for: .touchUpInside)
        startQuizzButton.layer.cornerRadius = startQuizzButton.frame.height/2
        
        questionDataSource.loadData()
        userVectorDataSource.loadData()
    }
    
    // MARK: - Button actions
    @objc func startQuiz(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: QuestionViewController.identifier) as? QuestionViewController, let userVector = userVector {
            vc.questions = questionsArray
            vc.isLastQuestion = false
            vc.questionTag = 0
            vc.userVector = userVector
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - QuestionDataModelDelegate
extension MenuViewController: QuestionDataModelDelegate {
    func didLoadQuizData(questions: [Question]) {
        questionsArray = questions
        startQuizzButton.isEnabled = true
        UserDefaults.standard.set(questionsArray.count, forKey: Question.questionsArrayKey)
        UserDefaults.standard.synchronize()
    }
    
    func didFailLoadingQuizData(error: Error) {
        showError()
    }
}

// MARK: - UserVectorDataModelDelegate
extension MenuViewController: UserVectorDataModelDelegate {
    func didLoadUserVectorData(userVector: UserVector) {
        self.userVector = userVector
    }
    
    func didFailLoadingUserVectorData(error: Error) {
        showError()
    }
}
