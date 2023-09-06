//
//  MyPageViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit



class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    private func customProfileButton() {
        profileButton.backgroundColor = UIColor.lightGray
        profileButton.setTitle("계정 정보 수정", for: .normal)
        profileButton.setTitleColor(UIColor.white, for: .normal)
        
        profileButton.layer.cornerRadius = 5
        profileButton.layer.borderWidth = 5
        profileButton.layer.borderColor = UIColor.lightGray.cgColor
        
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.masksToBounds = false
        profileButton.layer.shadowRadius = 1
        profileButton.layer.shadowOpacity = 0.5
        profileButton.layer.shadowOffset = CGSize.zero
    }
    
    private func customLogoutButton() {
        logoutButton.backgroundColor = UIColor.lightGray
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderWidth = 5
        logoutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.masksToBounds = false
        logoutButton.layer.shadowRadius = 1
        logoutButton.layer.shadowOpacity = 0.5
        logoutButton.layer.shadowOffset = CGSize.zero
    }
    
    @IBAction func idEditButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "RegistrationScene", bundle: nil)
        let moveVC = storyBoard.instantiateViewController(withIdentifier: RegistraionViewController.identifier) as! RegistraionViewController
        moveVC.modalPresentationStyle = .fullScreen
        moveVC.modalTransitionStyle = .crossDissolve
        moveVC.reuseTitle = "개인정보수정 페이지"
        moveVC.resueStartButton = "수정하기"
    
        self.present(moveVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "LoginScene", bundle: nil)
        let moveVC = storyBoard.instantiateViewController(withIdentifier: LoginViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        moveVC.modalTransitionStyle = .crossDissolve
        self.present(moveVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customProfileButton()
        customLogoutButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        profileImage.layer.cornerRadius = 50
        profileImage.layer.masksToBounds = true
        
        let nibName = UINib(nibName: "MyPageTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "MyPageTableViewCell")
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as! MyPageTableViewCell
        return cell
    }

}
