//
//  MyPageViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit



class MyPageViewController: UIViewController {
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

    @IBOutlet weak var MyPageCollectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var reuseYoutubeData = DataManager.shared.getLikedVideoList()
    
    private func customProfileButton() {
        profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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
        DataManager.shared.saveIslogin(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customProfileButton()
        customLogoutButton()
        
        MyPageCollectionView.dataSource = self
        MyPageCollectionView.delegate = self
        MyPageCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        
        profileImage.layer.cornerRadius = 50
        profileImage.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reuseYoutubeData = DataManager.shared.getLikedVideoList()
        MyPageCollectionView.reloadData()
    }
    
}

extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.mainViewIdentifier, for: indexPath) as! MainCollectionViewCell
        let url = URL(string: reuseYoutubeData[indexPath.row].thumbNail)
        
        cell.channelNameLabel.text = reuseYoutubeData[indexPath.row].channelId
        cell.videoThumbnailImage.load(url: url!)
        cell.channelImage.load(url: url!)
        cell.videoTitleLabel.text = reuseYoutubeData[indexPath.row].title
        cell.videoViewCountLabel.text = "\(reuseYoutubeData[indexPath.row].formatViewCount) 조회"
        cell.videoDateLabel.text = reuseYoutubeData[indexPath.row].uploadDateString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return DataManager.shared.getLikedVideoList().count
    }
    
}
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight - 90)

    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 5
        }
    
    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 5
        }
}


