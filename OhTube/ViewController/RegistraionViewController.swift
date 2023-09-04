//
//  RegistraionViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class RegistraionViewController: UIViewController {
    // MARK: - Properties
    static let storyboardName = "RegistraionScene"
    static let identifier = "RegistraionViewController"
    private let dataManager = DataManager.shared
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configure
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
    
    private func register() {
        guard let id = idTextField.text,
        let nickNmae = nickNameTextField.text,
        let passWord = passWordTextField.text else { return }
        let user = User(id: id, nickName: nickNmae, passWord: passWord)
        dataManager.createUser(user)
    }
    
    // MARK: - Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        register()
        let moveVC = ViewController()
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
}

// MARK: - UITextField Delegate
extension RegistraionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
