//
//  RegistraionViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

class RegistraionViewController: UIViewController {
    static let identifier = "RegistraionViewController"
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configure(backButton)
        configure(startButton)
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.cornerRadius = 5
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        print("startButton Tapped")
    }
    
}
