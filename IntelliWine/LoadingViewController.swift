//
//  LoadingViewController.swift
//  IntelliWine
//
//  Created by Cédric Rolland on 09/11/16.
//  Copyright © 2016 IntelliWine. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var alfredImageView: UIImageView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    var screenshot: UIImage?
    
    private var imageIndex = 0
    private let animations = [UIImage(named: "alfred_0"), UIImage(named: "alfred_1"), UIImage(named: "alfred_2")]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let screenshot = screenshot {
            screenshotImageView.image = screenshot
        }
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.bounds
        view.insertSubview(visualEffectView, at: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let timer = Timer.scheduledTimer(
            timeInterval: 0.3, target: self, selector: #selector(LoadingViewController.loopImage),
            userInfo: nil, repeats: true)
        timer.fire()
    }
    
    // MARK: - Actions
    @objc func loopImage() {
        alfredImageView.image = animations[(imageIndex % 3)]
        imageIndex += 1
    }
}
