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
    var mainTitle: String? = "회원가입"
    var startButtonTitle: String? = "시작하기"
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

    private var idIsDuplicate: Bool?
    private var passWordIsValid: Bool {
        checkValidate(passWord: passWord)
    }

    private var checkPassWordIsValid: Bool {
        passWord == checkedPassWord
    }

    private var formIsValid: Bool {
        idIsValid == true &&
            idIsDuplicate == false &&
            id == checkedDuplicateId &&
            passWordIsValid == true &&
            checkPassWordIsValid == true
    }

    private var startButtonBackgroundColor: UIColor { formIsValid ? UIColor.red : UIColor.lightGray }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var checkDuplicateIdButton: UIButton!
    @IBOutlet var idValidateLabel: UIButton!
    @IBOutlet var checkDuplicateIdLabel: UIButton!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    @IBOutlet var passWordSecureButton: UIButton!
    @IBOutlet var passWordValidateLabel: UIButton!
    @IBOutlet var checkPassWordTextField: UITextField!
    @IBOutlet var checkPassWordSecureButton: UIButton!
    @IBOutlet var checkPassWordValidateLabel: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Custom Component

    lazy var accessoryView: UIView = .init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
    
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
        idValidateLabel.isHidden = true
        checkDuplicateIdLabel.isHidden = true
        checkDuplicateIdButton.isHidden = true
        idIsDuplicate = false
        idTextField.backgroundColor = .lightGray.withAlphaComponent(0.5)
        idTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupUser() {
        guard let user = dataManager.getUser() else { return }
        id = user.id
        checkedDuplicateId = user.id
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
        titleLabel.text = title
        startButton.setTitle(startButtonTitle, for: .normal)
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
        accessoryView.addSubview(button)
        guard let superView = button.superview else { return }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 15).isActive = true
        button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -15).isActive = true
        button.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    // MARK: - Register

    private func register() {
        guard let id = id,
              let nickNmae = nickName,
              let passWord = passWord else { return }
        let user = User(id: id, nickName: nickNmae, passWord: passWord)
        dataManager.createUser(user)
        dataManager.saveUser(id: id)
        dataManager.saveIslogin(true)
    }
    
    // MARK: - Update Form

    private func updateForm() {
        startButton.backgroundColor = startButtonBackgroundColor
        formIsValid ? (startButton.isEnabled = true) : (startButton.isEnabled = false)
        if id != checkedDuplicateId {
            checkDuplicateIdLabel.tintColor = .red
            checkDuplicateIdLabel.titleLabel?.textColor = .red
        }
        if id?.isEmpty == false {
            idIsValid ? updateValidForm(idValidateLabel) : updateInValidForm(idValidateLabel)
        }
        if passWord?.isEmpty == false {
            passWordIsValid ? updateValidForm(passWordValidateLabel) : updateInValidForm(passWordValidateLabel)
            checkPassWordIsValid ? updateValidForm(checkPassWordValidateLabel) : updateInValidForm(checkPassWordValidateLabel)
        }
        if checkedPassWord?.isEmpty == false {
            passWordIsValid ? updateValidForm(passWordValidateLabel) : updateInValidForm(passWordValidateLabel)
            checkPassWordIsValid ? updateValidForm(checkPassWordValidateLabel) : updateInValidForm(checkPassWordValidateLabel)
        }
    }

    private func updateValidForm(_ label: UIButton) {
        label.tintColor = .blue
        label.titleLabel?.textColor = .blue
    }
    
    private func updateInValidForm(_ label: UIButton) {
        label.tintColor = .red
        label.titleLabel?.textColor = .red
    }
    
    private func updateDuplicateIdForm() {
        if checkDuplicate(id: id) == true {
            checkDuplicateIdLabel.tintColor = .red
            checkDuplicateIdLabel.titleLabel?.textColor = .red
        }
        if checkDuplicate(id: id) == false {
            checkDuplicateIdLabel.tintColor = .blue
            checkDuplicateIdLabel.titleLabel?.textColor = .blue
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
                return true
            }
        }
        return false
    }
    
    private func checkValidate(passWord: String?) -> Bool {
        guard let passWord = self.passWord else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", RegistraionForm.passWordRegex)
        return pred.evaluate(with: passWord)
    }
    
    // MARK: - Show Alert

    private func showAlert() {
        let alert = UIAlertController(title: "중복된 아이디", message: "아이디를 다시 입력해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - Actions

    @objc func textDidChange(_ textField: UITextField) {
        if textField == idTextField { id = idTextField.text }
        if textField == nickNameTextField { nickName = nickNameTextField.text }
        if textField == passWordTextField { passWord = passWordTextField.text }
        if textField == checkPassWordTextField { checkedPassWord = checkPassWordTextField.text }
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
        checkedDuplicateId = id
        if checkDuplicate(id: id) == true {
            showAlert()
            updateDuplicateIdForm()
            idIsDuplicate = true
            updateForm()
        }
        if checkDuplicate(id: id) == false {
            updateDuplicateIdForm()
            idIsDuplicate = false
            updateForm()
        }
    }
    
    private func enableSecureText(update textField: UITextField, _ button: UIButton) {
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        textField.isSecureTextEntry = false
    }
    
    private func disableSecureText(update textField: UITextField, _ button: UIButton) {
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        textField.isSecureTextEntry = true
    }
    
    @IBAction func passWordSecureButtonTapped(_ sender: UIButton) {
        passWordTextField.isSecureTextEntry ?
            enableSecureText(update: passWordTextField, passWordSecureButton) :
            disableSecureText(update: passWordTextField, passWordSecureButton)
    }
    
    @IBAction func checkPassWordSecureButtonTapped(_ sender: UIButton) {
        checkPassWordTextField.isSecureTextEntry ?
            enableSecureText(update: checkPassWordTextField, checkPassWordSecureButton) :
            disableSecureText(update: checkPassWordTextField, checkPassWordSecureButton)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if title == "회원가입" {
            register()
            let moveVC = TabbarViewController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(moveVC, animation: true)
        } else {
            guard let id = id,
                  let nickName = nickName,
                  let passWord = passWord else { return }
            let user = User(id: id, nickName: nickName, passWord: passWord)
            dataManager.updateUser(user)
            dismiss(animated: true)
        }
    }
    
    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
