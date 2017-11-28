//
//  QuestionType1ViewController.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 19/10/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import UIKit
import Alamofire

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var previousQuestionButton: UIButton!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    var questions: [Question]?
    var questionTag: Int?
    var userVector: UserVector?
    var isLastQuestion: Bool?
    var exclusiveIndexes: [Int] = []
    
    private var questionCount: Int?
    private var modalVC: LoadingViewController?
    private var question: Question?
    private let userVectorDataSource = UserVectorDataModel()
    private let similarityScoreDataSource = SimilarityScoreDataModel()
    private let margin1: CGFloat = 60
    private let margin2: CGFloat = 95
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        similarityScoreDataSource.delegate = self
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.rowHeight = UITableViewAutomaticDimension
        answersTableView.estimatedRowHeight = 100
        
        view.backgroundColor = myColor.lightGray
        
        setupButtons()
        setupTitle()
        setupQuestion()
    }
    
    func setupQuestion() {
        guard let questions = questions, let index = questionTag else {
            showError()
            return
        }
        question = questions[index]
        questionLabel.text = question?.question
    }
    
    func setupTitle() {
        guard let index = questionTag else {
            showError()
            return
        }
        questionCount = UserDefaults.standard.object(forKey: Question.questionsArrayKey) as? Int
        
        if let questionCount = questionCount {
            title = "Question \(index + 1)/\(questionCount)"
        }
    }
    
    func setupButtons() {
        guard let isLastQuestion = isLastQuestion else {
            showError()
            return
        }
        if isLastQuestion {
            nextQuestionButton.setImage(UIImage(named: "recommend"), for: UIControlState())
            nextQuestionButton.setImage(UIImage(named: "recommend_pressed"), for: .highlighted)
            nextQuestionButton.addTarget(self, action: #selector(QuestionViewController.computeSimilarity(_:)), for: .touchUpInside)
        } else {
            nextQuestionButton.addTarget(self, action: #selector(QuestionViewController.nextQuestion(_:)), for: .touchUpInside)
        }
        previousQuestionButton.addTarget(self, action: #selector(QuestionViewController.back(_:)), for: .touchUpInside)
    }
 
    // MARK: - Button actions
    @objc func nextQuestion(_ sender: UIButton) {
        userVector?.lockAll()
        if let vc = storyboard?.instantiateViewController(withIdentifier: QuestionViewController.identifier) as? QuestionViewController,
           let index = questionTag, let questionCount = questionCount {
            vc.questions = questions
            vc.questionTag = index + 1
            vc.userVector = userVector
            vc.isLastQuestion = !(index + 1 < questionCount - 1 )
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }    
}

// MARK: - UITableViewDataSource
extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let answers = question?.answers {
            return answers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier) as? AnswerCell,
           let answer = question?.answers[indexPath.row] {
            cell.config(withAnswer: answer)
            if answer.isExclusive {
                exclusiveIndexes.append(indexPath.row)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AnswerCell, let answers = question?.answers {
            if (answers[indexPath.row]).isExclusive {
                disableAllBox(tableView: tableView, indexPath: indexPath, maxRow: answers.count)
            } else {
                uncheckDisabledBox(tableView: tableView, indexPath: indexPath, maxRow: answers.count)
            }
            
            userVector?.changeLock(tags: answers[indexPath.row].tags, newLock: cell.isActive ?
                (value: 0, locked: .unlocked) : (value: 1, locked: .tmpLocked))
            checkBox(cell: cell, state: "checkbox_active")
            cell.isActive = !cell.isActive
        }
    }
    
    func checkBox(cell: AnswerCell, state: String) {
        let answerCheckboxImage = cell.isActive ? UIImage(named: "checkbox_empty") : UIImage(named: state)
        cell.answerCheckbox.image = answerCheckboxImage?.withRenderingMode(.alwaysTemplate)
    }
    
    func uncheckDisabledBox(tableView: UITableView, indexPath: IndexPath, maxRow: Int) {
        // the double loop run only once since the tmpCell.isActive is true only once.
        for (_, index) in exclusiveIndexes.enumerated() {
            if let tmpCell = tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? AnswerCell, tmpCell.isActive {
                for i in 0..<maxRow {
                    if let _tmpCell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? AnswerCell {
                        uncheckBox(cell: _tmpCell)
                    }
                }
            }
        }
    }
    
    func uncheckBox(cell: AnswerCell) {
        cell.answerCheckbox.image = UIImage(named: "checkbox_empty")?.withRenderingMode(.alwaysTemplate)
        cell.isActive = false
    }
    
    func disableAllBox(tableView: UITableView, indexPath: IndexPath, maxRow: Int) {
        for i in 0..<maxRow {
            if let tmpCell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? AnswerCell {
                tmpCell.isActive = false
                checkBox(cell: tmpCell, state: "checkbox_disabled")
            }
        }
    }
}

// MARK: - SimilarityScoreDataModelDelegate
extension QuestionViewController: SimilarityScoreDataModelDelegate {
    @objc func computeSimilarity(_ sender: UIButton) {
        modalVC = storyboard?.instantiateViewController(withIdentifier: LoadingViewController.identifier) as? LoadingViewController
        if let modalVC = modalVC, let userVector = userVector {
            modalVC.screenshot = UIApplication.shared.keyWindow?.capture()
            modalVC.modalPresentationStyle = .custom
            modalVC.modalTransitionStyle = .crossDissolve
            
            present(modalVC, animated: true, completion: {
                do {
                    try self.similarityScoreDataSource.computeSimilarity(userVector: userVector)
                } catch {
                    self.showError()
                }
            })
        }
    }
    
    func didComputeSimilaritySuccesfully(answer: Double) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: QuizAnswerViewController.identifier) as? QuizAnswerViewController {
            vc.answerText = "\(answer)"
            navigationController?.pushViewController(vc, animated: true)
            modalVC?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didFailComputingSimilarity(error: Error) {
        modalVC?.dismiss(animated: true, completion: {
            self.showError()
        })
    }
}
