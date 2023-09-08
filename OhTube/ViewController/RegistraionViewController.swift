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
    var user: User? {
        didSet {
            setupData()
        }
    }
    private var id: String?
    private var nickName: String?
    private var passWord: String?
    private var checkedPassWord: String?
    private let dataManager = DataManager.shared
    private var idIsValid: Bool {
        id?.isEmpty == false &&
        checkValidate(id: id)
    }
    private var passWordIsValid: Bool {
        passWord?.isEmpty == false &&
        passWord == checkedPassWord &&
        checkValidate(passWord: passWord)
    }
    private var formIsValid: Bool {
        idIsValid == true &&
        passWordIsValid == true
    }
    private var startButtonBackgroundColor: UIColor { formIsValid ? UIColor.red : UIColor.lightGray }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var checkIdLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var passWordSecureButton: UIButton!
    @IBOutlet weak var passWordValidateLabel: UILabel!
    @IBOutlet weak var checkPassWordTextField: UITextField!
    @IBOutlet weak var checkPassWordSecureButton: UIButton!
    @IBOutlet weak var checkedPassWordLabel: UILabel!
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
    
    deinit {
        print("RegistraionViewController 사라집니다~")
    }
    
    // MARK: - Data Setting
    private func setupData() {
        idTextField.text = user?.id
        nickNameTextField.text = user?.nickName
        passWordTextField.text = user?.passWord
        checkPassWordTextField.text = user?.passWord
        id = user?.id
        nickName = user?.nickName
        passWord = user?.passWord
        checkedPassWord = user?.passWord
        titleLabel.text = self.reuseTitle
        startButton.setTitle(self.resueStartButton, for: .normal)
        idTextField.isEnabled = false
        idTextField.backgroundColor = .lightGray.withAlphaComponent(0.8)
        idTextField.layer.borderColor = UIColor.clear.cgColor
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
        textField.inputAccessoryView = accessoryView
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5
    }
    
    private func configure() {
        titleLabel.text = reuseTitle
        startButton.setTitle(resueStartButton, for: .normal)
        startButton.layer.borderColor = UIColor.clear.cgColor
        passWordTextField.isSecureTextEntry = true
        passWordTextField.textContentType = .oneTimeCode
        checkPassWordTextField.isSecureTextEntry = true
        checkPassWordTextField.textContentType = .oneTimeCode
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
        updateIdForm()
        updatePassWordForm()
        updateCheckPassWordForm()
    }
    
    private func updateIdForm() {
        checkIdLabel.isHidden = false
        if idIsValid == true {
            checkIdLabel.textColor = .blue
            checkIdLabel.text = "* 사용 가능한 아이디입니다."
        }
        if idIsValid == false {
            checkIdLabel.textColor = .red
            checkIdLabel.text = "* 형식에 맞지 않는 아이디입니다."
        }
    }
    
    private func updatePassWordForm() {
        guard let passWord = self.passWord else { return }
        passWordValidateLabel.isHidden = false
        if checkValidate(passWord: passWord) == true {
            passWordValidateLabel.text = "* 사용 가능한 비밀번호입니다."
            passWordValidateLabel.textColor = .blue
        }
        if checkValidate(passWord: passWord) == false {
            passWordValidateLabel.text = "* 형식에 맞지 않는 비밀번호입니다."
            passWordValidateLabel.textColor = .red
        }
    }
    
    private func updateCheckPassWordForm() {
        checkedPassWordLabel.isHidden = false
        if passWord == checkedPassWord && passWord?.isEmpty == false {
            checkedPassWordLabel.text = "* 비밀번호가 일치합니다."
            checkedPassWordLabel.textColor = .blue
        }
        if passWord != checkedPassWord && passWord?.isEmpty == false {
            checkedPassWordLabel.text = "* 비밀번호가 일치하지 않습니다."
            checkedPassWordLabel.textColor = .red
        }
    }
    
    // MARK: - Validation ID
    private func checkValidate(id: String?) -> Bool {
        guard let id = self.id else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", RegistraionForm.idRegex)
        return pred.evaluate(with: id)
    }
    
    private func checkDuplicate(id: String) -> Bool {
        let userList = dataManager.getUserList()
        for user in userList {
            if user.id == self.id {
                checkIdLabel.text = "* 중복된 아이디입니다."
                checkIdLabel.textColor = .red
                return false
            }
        }
        checkIdLabel.text = "* 사용 가능한 아이디입니다."
        checkIdLabel.textColor = .blue
        return true
    }
    
    // MARK: - Validation Password
    private func checkValidate(passWord: String?) -> Bool {
        guard let passWord = self.passWord else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", RegistraionForm.passWordRegex)
        return pred.evaluate(with: passWord)
    }
    
    // MARK: - Action
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
        print(text.count)
        return text.count < 20
    }
}

extension UIViewController {
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y == 0.0 {
                self.view.frame.origin.y -= 45
        }
    }

    @objc private func hideKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
                self.view.frame.origin.y += 45
        }
    }
}
