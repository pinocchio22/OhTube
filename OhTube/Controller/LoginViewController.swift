//
//  LoginViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties

    static let storyboardName = "LoginScene"
    static let identifier = "LoginViewController"
    private let dataManager = DataManager.shared
    private var id: String?
    private var passWord: String?
    private var formIsValid: Bool { id?.isEmpty == false && passWord?.isEmpty == false }
    private var loginButtonBackgroundColor: UIColor { formIsValid ? UIColor.red : UIColor.lightGray }
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    @IBOutlet var passWordSecureButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registrationButton: UIButton!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setKeyboardNotification()
    }
    
    // MARK: - Configure

    private func configureUI() {
        configure(loginButton)
        configure(registrationButton)
        configure(idTextField)
        configure(passWordTextField)
        configure()
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func configure() {
        loginButton.layer.borderColor = UIColor.clear.cgColor
        idTextField.textContentType = .name
        passWordTextField.isSecureTextEntry = true
        passWordTextField.textContentType = .newPassword
    }
    
    private func updateForm() {
        loginButton.backgroundColor = loginButtonBackgroundColor
        if formIsValid { loginButton.isEnabled = true }
        if formIsValid == false { loginButton.isEnabled = false }
    }
    
    private func userValidation() -> Bool {
        let userList = dataManager.getUserList()
        for user in userList {
            if user.id == id && user.passWord == passWord {
                return true
            }
        }
        return false
    }
    
    private func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 10)
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    
    // MARK: - Action

    @objc private func textDidChange(_ textField: UITextField) {
        if textField == idTextField { id = idTextField.text }
        if textField == passWordTextField { passWord = passWordTextField.text }
        updateForm()
    }
    
    @IBAction func passWordSecureButtonTapped(_ sender: UIButton) {
        if passWordTextField.isSecureTextEntry == true {
            passWordSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passWordTextField.isSecureTextEntry = false
        } else {
            passWordSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passWordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if userValidation() {
            let moveVC = TabbarViewController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(moveVC, animation: true)
        }
        if userValidation() == false {
            showToast(message: Message.toast)
        }
        guard let id = id else { return }
        dataManager.saveIslogin(true)
        dataManager.saveUser(id: id)
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: RegistraionViewController.storyboardName, bundle: nil)
        let moveVC = storyboard.instantiateViewController(withIdentifier: RegistraionViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
    
    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
