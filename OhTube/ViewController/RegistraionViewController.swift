//
//  RegistraionViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

final class RegistraionViewController: UIViewController {
    // MARK: - Properties
    
    var reuseTitle: String? = "회원가입"
    var resueStartButton: String? = "시작하기"
    
    static let storyboardName = "RegistrationScene"
    static let identifier = "RegistraionViewController"
    private let dataManager = DataManager.shared
    private var id: String?
    private var nickName: String?
    private var passWord: String?
    private var checkedPassWord: String?
    private var idIsValid: Bool {
        guard let id = self.id else { return false }
        return validation(id: id)
    }
    private var passWordIsValid: Bool { passWord == checkedPassWord }
    private var formIsValid: Bool {
        idIsValid == true &&
        nickName?.isEmpty == false &&
        passWord?.isEmpty == false &&
        passWordIsValid == true
    }
    private var startButtonBackgroundColor: UIColor { formIsValid ? UIColor.systemPink : UIColor.lightGray }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    @IBOutlet weak var checkedPassWordLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        titleLabel.text = reuseTitle
        startButton.setTitle(resueStartButton, for: .normal)
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
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func configure() {
        startButton.layer.borderColor = UIColor.clear.cgColor
        passWordTextField.isSecureTextEntry = true
        passWordTextField.textContentType = .newPassword
        checkPassWordTextField.isSecureTextEntry = true
        checkedPassWordLabel.isHidden = true
    }
    
    private func register() {
        guard let id = self.id,
              let nickNmae = self.nickName,
              let passWord = self.passWord else { return }
        let user = User(id: id, nickName: nickNmae, passWord: passWord)
        dataManager.createUser(user)
        dataManager.saveUser(id: id)
    }
    
    private func updateForm() {
        startButton.backgroundColor = startButtonBackgroundColor
        if formIsValid == true { startButton.isEnabled = true }
        if formIsValid == false { startButton.isEnabled = false }
        if passWord?.isEmpty == true && checkedPassWord?.isEmpty == true {
            checkedPassWordLabel.isHidden = true
        }
        if passWord?.isEmpty == false && checkedPassWord?.isEmpty == false {
            updatePassWordForm()
        }
    }
    
    private func updatePassWordForm() {
        checkedPassWordLabel.isHidden = false
        if passWordIsValid == true {
            checkedPassWordLabel.text = "비밀번호가 일치합니다."
            checkedPassWordLabel.textColor = .blue
        }
        if passWordIsValid == false {
            checkedPassWordLabel.text = "비밀번호가 일치하지 않습니다."
            checkedPassWordLabel.textColor = .red
        }
    }
    
    private func validation(id: String) -> Bool {
        let userList = dataManager.getUserList()
        for user in userList {
            if user.id == self.id {
                print("ID 중복입니다!!!!!!!")
                return false
            }
        }
        return true
    }
    
    // MARK: - Action
    @objc func textDidChange(_ textField: UITextField) {
        if textField == idTextField { self.id = idTextField.text }
        if textField == nickNameTextField { self.nickName = nickNameTextField.text }
        if textField == passWordTextField { self.passWord = passWordTextField.text }
        if textField == checkPassWordTextField { self.checkedPassWord = checkPassWordTextField.text }
        updateForm()
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
