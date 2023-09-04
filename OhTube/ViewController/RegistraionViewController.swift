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
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        idTextField.delegate = self
    }
    
    private func configureUI() {
        configure(backButton)
        configure(startButton)
        configure(idTextField)
        configure(nickNameTextField)
        configure(passWordTextField)
        configure(checkPassWordTextField)
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.systemPink.cgColor
        textField.layer.cornerRadius = 5
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
        let moveVC = ViewController()
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
}

extension RegistraionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
