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
    private var loginButtonBackgroundColor: UIColor { formIsValid ? UIColor.systemPink : UIColor.lightGray }
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("LoginViewController 사라집니다~")
    }
    
    // MARK: - Configure
    private func configureUI() {
        configure(loginButton)
        configure(registrationButton)
        configure(idTextField)
        configure(passWordTextField)
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
        loginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func updateForm(button: UIButton) {
        button.backgroundColor = loginButtonBackgroundColor
        if formIsValid { button.isEnabled = true }
        if formIsValid == false { button.isEnabled = false }
    }
    
    private func userValidation() -> Bool {
        let userList = dataManager.getUserList()
        for user in userList {
            if user.id == self.id && user.passWord == self.passWord {
                return true
            }
        }
        return false
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 2
        self.view.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            toastLabel.widthAnchor.constraint(equalToConstant: self.view.frame.size.width / 2),
            toastLabel.heightAnchor.constraint(equalToConstant: self.view.frame.height / 10)
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) {
            toastLabel.alpha = 0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    // MARK: - Action
    @objc private func textDidChange(_ textField: UITextField) {
        if textField == idTextField { self.id = idTextField.text }
        if textField == passWordTextField { self.passWord = passWordTextField.text }
        updateForm(button: loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if userValidation() {
            let moveVC = ViewController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(moveVC, animation: true)
        }
        if userValidation() == false {
            showToast(message: Message.toast)
        }
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: RegistraionViewController.storyboardName, bundle: nil)
        let moveVC = storyboard.instantiateViewController(withIdentifier: RegistraionViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
}

// MARK: - UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
