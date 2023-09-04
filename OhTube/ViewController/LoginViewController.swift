//
//  LoginViewController.swift
//  OhTube
//
//  Created by playhong on 2023/09/04.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        configure(loginButton)
        configure(registrationButton)
    }
    
    private func configure(_ button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.layer.cornerRadius = 5
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RegistrationScene", bundle: nil)
        let moveVC = storyboard.instantiateViewController(withIdentifier: RegistraionViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        present(moveVC, animated: true)
    }
    
}
