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
    var reuseTitle: String? = "회원가입"
    var resueStartButton: String? = "시작하기"
    private var id: String?
    private var checkedDuplicateId: String?
    private var nickName: String?
    private var passWord: String?
    private var checkedPassWord: String?
    private let dataManager = DataManager.shared
    private let maxTextCount = 20
    private var idIsValid: Bool {
        checkValidate(id: id)
    }
    private var idIsDuplicate: Bool {
        checkDuplicate(id: id)
    }
    private var passWordIsValid: Bool {
        checkValidate(passWord: passWord)
    }
    private var checkPassWordIsValid: Bool {
        passWord == checkedPassWord
    }
    private var formIsValid: Bool {
        idIsValid == true &&
        id == checkedDuplicateId &&
        passWordIsValid == true &&
        checkPassWordIsValid == true
    }
    private var startButtonBackgroundColor: UIColor { formIsValid ? UIColor.red : UIColor.lightGray }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var checkDuplicateIdButton: UIButton!
    @IBOutlet weak var idValidateLabel: UIButton!
    @IBOutlet weak var checkDuplicateIdLabel: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var passWordSecureButton: UIButton!
    @IBOutlet weak var passWordValidateLabel: UIButton!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    @IBOutlet weak var checkPassWordSecureButton: UIButton!
    @IBOutlet weak var checkPassWordValidateLabel: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Custom Component
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
    }()
    
    lazy var inputCompletionButton: UIButton = {
        let button = UIButton()
        button.setTitle("입력 완료", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(inputCompletionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setKeyboardNotification()
    }
    
    // MARK: - EditProfile Transition Setup
    func setupEditProfile() {
        setupUser()
        configure()
        idTextField.isEnabled = false
        idTextField.backgroundColor = .lightGray.withAlphaComponent(0.5)
        idTextField.layer.borderColor = UIColor.clear.cgColor
        idValidateLabel.isHidden = true
    }
    
    private func setupUser() {
        guard let user = dataManager.getUser() else { return }
        id = user.id
        nickName = user.nickName
        passWord = user.passWord
        checkedPassWord = user.passWord
        setupUserData(user)
    }
    
    private func setupUserData(_ user: User) {
        idTextField.text = user.id
        nickNameTextField.text = user.nickName
        passWordTextField.text = user.passWord
        checkPassWordTextField.text = user.passWord
    }

    // MARK: - Configure
    private func configureUI() {
        configure(checkDuplicateIdButton)
        configure(backButton)
        configure(startButton)
        configure(idTextField)
        configure(nickNameTextField)
        configure(passWordTextField)
        configure(checkPassWordTextField)
        configurePassWordTextField(passWordTextField)
        configurePassWordTextField(checkPassWordTextField)
        configure()
    }
    
    private func configure() {
        titleLabel.text = self.reuseTitle
        startButton.setTitle(resueStartButton, for: .normal)
        startButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.inputAccessoryView = accessoryView
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func configurePassWordTextField(_ textField: UITextField) {
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        inputCompletionButtonConstraints(inputCompletionButton)
    }
    
    private func inputCompletionButtonConstraints(_ button: UIButton) {
        self.accessoryView.addSubview(button)
        guard let superView = button.superview else { return }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 15).isActive = true
        button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -15).isActive = true
        button.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // MARK: - Register
    private func register() {
        guard let id = self.id,
              let nickNmae = self.nickName,
              let passWord = self.passWord else { return }
        let user = User(id: id, nickName: nickNmae, passWord: passWord)
        dataManager.createUser(user)
        dataManager.saveUser(id: id)
        dataManager.saveIslogin(true)
    }
    
    // MARK: - Update Form
    private func updateForm() {
        startButton.backgroundColor = startButtonBackgroundColor
        if formIsValid == true { startButton.isEnabled = true }
        if formIsValid == false { startButton.isEnabled = false }
        if id != checkedDuplicateId {
            checkDuplicateIdLabel.tintColor = .red
            checkDuplicateIdLabel.titleLabel?.textColor = .red
        }
        updateIdForm()
        updatePassWordForm()
        updateCheckPassWordForm()
    }
    
    private func updateIdForm() {
        guard let _ = self.id else { return }
        if idIsValid == true {
            idValidateLabel.tintColor = .blue
            idValidateLabel.titleLabel?.textColor = .blue
        }
        if idIsValid == false {
            idValidateLabel.tintColor = .red
            idValidateLabel.titleLabel?.textColor = .red
        }
    }
    
    private func updateDuplicateIdForm() {
        if idIsDuplicate == true {
            checkDuplicateIdLabel.tintColor = .blue
            checkDuplicateIdLabel.titleLabel?.textColor = .blue
        }
        if idIsDuplicate == false {
            checkDuplicateIdLabel.tintColor = .red
            checkDuplicateIdLabel.titleLabel?.textColor = .red
        }
    }
    
    private func updatePassWordForm() {
        guard let _ = self.passWord else { return }
        if passWordIsValid == true {
            passWordValidateLabel.tintColor = .blue
            passWordValidateLabel.titleLabel?.textColor = .blue
        }
        if passWordIsValid == false {
            passWordValidateLabel.tintColor = .red
            passWordValidateLabel.titleLabel?.textColor = .red
        }
    }
    
    private func updateCheckPassWordForm() {
        guard let _ = self.checkedPassWord else { return }
        if checkPassWordIsValid == true {
            checkPassWordValidateLabel.tintColor = .blue
            checkPassWordValidateLabel.titleLabel?.textColor = .blue
        }
        if checkPassWordIsValid == false {
            checkPassWordValidateLabel.tintColor = .red
            checkPassWordValidateLabel.titleLabel?.textColor = .red
        }
    }
    
    // MARK: - Validation
    private func checkValidate(id: String?) -> Bool {
        guard let id = self.id else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", RegistraionForm.idRegex)
        return pred.evaluate(with: id)
    }
    
    private func checkDuplicate(id: String?) -> Bool {
        guard let _ = self.id else { return false }
        let userList = dataManager.getUserList()
        for user in userList {
            if user.id == self.id {
                return false
            }
        }
        return true
    }
    
    private func checkValidate(passWord: String?) -> Bool {
        guard let passWord = self.passWord else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", RegistraionForm.passWordRegex)
        return pred.evaluate(with: passWord)
    }
    
    // MARK: - Actions
    @objc func textDidChange(_ textField: UITextField) {
        if textField == idTextField { self.id = idTextField.text }
        if textField == nickNameTextField { self.nickName = nickNameTextField.text }
        if textField == passWordTextField { self.passWord = passWordTextField.text }
        if textField == checkPassWordTextField { self.checkedPassWord = checkPassWordTextField.text }
        updateForm()
    }
    
    @objc func inputCompletionButtonTapped(_ sender: UIButton) {
        if idTextField.isFirstResponder == true {
            nickNameTextField.becomeFirstResponder()
            return
        }
        if nickNameTextField.isFirstResponder == true {
            passWordTextField.becomeFirstResponder()
            return
        }
        if passWordTextField.isFirstResponder == true {
            checkPassWordTextField.becomeFirstResponder()
            return
        }
        if checkPassWordTextField.isFirstResponder == true {
            checkPassWordTextField.resignFirstResponder()
            return
        }
    }
    
    @IBAction func checkDuplicateIdButtonTapped(_ sender: UIButton) {
        updateDuplicateIdForm()
        checkedDuplicateId = id
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
    
    @IBAction func checkPassWordSecureButtonTapped(_ sender: UIButton) {
        if checkPassWordTextField.isSecureTextEntry == true {
            checkPassWordSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            checkPassWordTextField.isSecureTextEntry = false
        } else {
            checkPassWordSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
            checkPassWordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if reuseTitle == "회원가입" {
            register()
            let moveVC = ViewController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(moveVC, animation: true)
        } else {
            guard let id = self.id,
                  let nickName = self.nickName,
                  let passWord = self.passWord else { return }
            let user = User(id: id, nickName: nickName, passWord: passWord)
            dataManager.updateUser(user)
            dismiss(animated: true)
        }
    }
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return text.count < maxTextCount
    }
}

extension UIViewController {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y == 0.0 {
                self.view.frame.origin.y -= 85
        }
    }

    @objc private func hideKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
                self.view.frame.origin.y += 85
        }
    }
}
