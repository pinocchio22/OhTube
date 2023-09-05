//
//  RegistraionViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class RegistraionViewController: UIViewController {
    // MARK: - Properties
    static let storyboardName = "RegistrationScene"
    static let identifier = "RegistraionViewController"
    private let dataManager = DataManager.shared
    private var id: String?
    private var nickName: String?
    private var passWord: String?
    private var checkedPassWord: String?
    private var formIsValid: Bool {
        id?.isEmpty == false &&
        nickName?.isEmpty == false &&
        passWord?.isEmpty == false &&
        passWordIsValid == true }
    private var passWordIsValid: Bool { passWord == checkedPassWord }
    private var startButtonBackgroundColor: UIColor { formIsValid ? UIColor.systemPink : UIColor.lightGray }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("RegistraionViewController 사라집니다~")
    }
    
    // MARK: - Configure
    private func configureUI() {
        configure(backButton)
        configure(startButton)
        configure(idTextField)
        configure(nickNameTextField)
        configure(passWordTextField)
        configure(checkPassWordTextField)
        startButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
    
    private func updateForm(button: UIButton) {
        button.backgroundColor = startButtonBackgroundColor
        if formIsValid { button.isEnabled = true }
        if formIsValid == false { button.isEnabled = false }
    }
    
    // MARK: - Action
    @objc func textDidChange(_ textField: UITextField) {
        if textField == idTextField { self.id = idTextField.text }
        if textField == nickNameTextField { self.nickName = nickNameTextField.text }
        if textField == passWordTextField { self.passWord = passWordTextField.text }
        if textField == checkPassWordTextField { self.checkedPassWord = checkPassWordTextField.text }
        startButton.isEnabled = true
        updateForm(button: startButton)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        register()
        let moveVC = ViewController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.changeRootViewController(moveVC, animation: true)
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
