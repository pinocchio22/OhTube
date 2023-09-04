//
//  LoginViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    static let identifier = "LoginViewController"
    private var id: String?
    private var password: String?
    private var formIsValid: Bool { id?.isEmpty == false && password?.isEmpty == false }
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
    
    // MARK: - Configure
    private func configureUI() {
        configure(loginButton)
        configure(registrationButton)
        configure(idTextField)
        configure(passWordTextField)
        loginButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.systemPink.cgColor
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func updateForm() {
        loginButton.backgroundColor = loginButtonBackgroundColor
    }
    
    // MARK: - Action
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let moveVC = ViewController()
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: RegistraionViewController.storyboardName, bundle: nil)
        let moveVC = storyboard.instantiateViewController(withIdentifier: RegistraionViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if textField == idTextField { self.id = idTextField.text }
        if textField == passWordTextField { self.password = passWordTextField.text }
        updateForm()
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
