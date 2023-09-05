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
    
    private func customButton() {
        profileButton.layer.borderWidth = 1
        logoutButton.layer.borderWidth = 1
        
    }
    
    private func shadowButton() {
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.masksToBounds = false
        profileButton.layer.shadowRadius = 3
        profileButton.layer.shadowOpacity = 0.4
        profileButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        logoutButton.layer.shadowColor = UIColor.blue.cgColor
        logoutButton.layer.masksToBounds = false
        logoutButton.layer.shadowRadius = 3
        logoutButton.layer.shadowOpacity = 0.4
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    @IBAction func idEditButtonTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "RegistrationScene", bundle: nil)
        let moveVC = storyBoard.instantiateViewController(withIdentifier: RegistraionViewController.identifier)
        moveVC.modalPresentationStyle = .fullScreen
        moveVC.modalTransitionStyle = .crossDissolve
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
        shadowButton()
        
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
