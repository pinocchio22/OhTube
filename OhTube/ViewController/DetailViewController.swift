///
//  DetailViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: variable
    var commentList = [Comment]()
    
    var likedVideoList = [Video]()
    var selectedVideo: Video?

//    var video: Video? {
//        didSet {
//            titleLabel.text = video?.title
//            videoTitle.text = video?.channelId
//            uploadDate.text = video?.uploadDateString
//            viewCount.text = "\(video!.viewCount) 조회"
//        }
//    }

    var profileImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame.size.width = 60
        image.frame.size.height = 60
        return image
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "제목 제목 제목 제목 제목 제목"
        label.font = Font.mainTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var videoWebView: UIWebView = {
        var view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var infoView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    var videoTitle: UILabel = {
        var label = UILabel()
        label.text = "원훈이와 영식이"
        label.font = Font.contentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewCount: UILabel = {
        var label = UILabel()
        label.text = "15.5만"
        label.font = Font.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var uploadDate: UILabel = {
        var label = UILabel()
        label.text = "20시간 전"
        label.font = Font.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var videoDescription: UILabel = {
        var label = UILabel()
        label.text = "설명입니다."
        label.font = Font.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likeButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.frame.size.width = 60
        btn.frame.size.height = 60
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return btn
    }()
    
//    var isLikedButton = false
    
    var commentView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var editCommentName: UILabel = {
        var label = UILabel()
        label.text = "닉네임"
        label.font = Font.commentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var editCommentContent: UITextField = {
        var tf = UITextField()
        tf.placeholder = "댓글"
        tf.font = Font.commentFont
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var editCommentButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.app"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var commentTableView: UITableView = {
        var tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return tv
    }()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        // load userDate
        
        // commentList = selectedVido.comment
        commentList = DataManager.shared.getCommentList().sorted{ $0.date > $1.date }
        
        setUI()
    }
    
    // MARK: function
    
    // setting UI
    func setUI() {
        setProfileImage()
        setTitleLabel()
        setVideoUView()
        setInfoView()
        setCommentView()
    }
    
    func setProfileImage() {
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        profileImage.image = Util.util.imageWith(name: selectedVideo?.channelId)
    }
    
    func setTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: profileImage.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        titleLabel.backgroundColor = .systemGray4
        
        titleLabel.text = selectedVideo?.channelId
    }
    
    func setVideoUView() {
        view.addSubview(videoWebView)
        
        NSLayoutConstraint.activate([
            videoWebView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            videoWebView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            videoWebView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // connect video in webview
        //        guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else { return  }
//        var url1 = "https://www.youtube.com/watch?v=prjjnxXBkpo"
//        var url2 = "https://www.youtube.com/embed/9bZkp7q19f0"
//        var url3 = "https://www.youtube.com/embed/5t0IwokCKlY"
//        var url4 = "https://www.youtube.com/embed/43FZXOo6oRM"
        
        videoWebView.allowsInlineMediaPlayback = true
        guard let url = URL(string: "https://www.youtube.com/embed/\(selectedVideo!.id)") else { return }
        videoWebView.loadRequest(URLRequest(url: url))
    }
    
    // MARK: infoView
    // set video info group
    func setInfoView() {
        view.addSubview(infoView)
        setVideoTitle()
        setViewCount()
        setUploadDate()
        setLikeButton()
        setVideoDescription()
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: videoWebView.bottomAnchor, constant: 10),
            infoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func setVideoTitle() {
        infoView.addSubview(videoTitle)
        
        NSLayoutConstraint.activate([
            videoTitle.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            videoTitle.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
        
        videoTitle.text = selectedVideo?.title
    }
    
    func setViewCount() {
        infoView.addSubview(videoDescription)
        infoView.addSubview(viewCount)
        
        NSLayoutConstraint.activate([
            viewCount.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 10),
            viewCount.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            viewCount.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            viewCount.bottomAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.topAnchor, constant: -10),
            viewCount.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        viewCount.text = selectedVideo?.viewCount
    }
    
    func setUploadDate() {
        infoView.addSubview(likeButton)
        
        infoView.addSubview(uploadDate)
       
        
        NSLayoutConstraint.activate([
            uploadDate.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 10),
            uploadDate.leadingAnchor.constraint(equalTo: viewCount.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            uploadDate.trailingAnchor.constraint(equalTo: likeButton.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            uploadDate.bottomAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.topAnchor, constant: -10),
        ])
        
        uploadDate.text = selectedVideo?.uploadDateString
    }
    
    func setLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: videoTitle.trailingAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            likeButton.bottomAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.topAnchor, constant: -10),
//            likeButton.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        likeButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeButton.layer.borderWidth = 1
        likeButton.layer.borderColor = UIColor.black.cgColor
        
        likeButton.setImage(DataManager.shared.getLikedVideoList().filter{ $0.id == selectedVideo?.id }.isEmpty ? UIImage(systemName: "bookmark") : UIImage(systemName: "bookmark.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
    }
    
    func setVideoDescription() {
        NSLayoutConstraint.activate([
            videoDescription.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            videoDescription.bottomAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            videoDescription.widthAnchor.constraint(equalTo: infoView.widthAnchor, constant:  -10),
//            videoDescription.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        videoDescription.text = selectedVideo?.description
    }
    
    // MARK: commentView
    // set comment group
    func setCommentView() {
        view.addSubview(commentView)
        setEditCommentName()
        setEditCommentContent()
        setEditCommentButton()
        setCommentTableView()
        
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            commentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            commentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setEditCommentName() {
        commentView.addSubview(editCommentName)
        commentView.addSubview(commentTableView)
        
        NSLayoutConstraint.activate([
            editCommentName.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            editCommentName.leadingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            editCommentName.bottomAnchor.constraint(equalTo: commentTableView.safeAreaLayoutGuide.topAnchor, constant: 10),
            editCommentName.widthAnchor.constraint(equalToConstant: 100)
        ])
        
//        editCommentName.text = "유저 닉네임"
        
    }
    
    func setEditCommentContent() {
        commentView.addSubview(editCommentContent)
        
        NSLayoutConstraint.activate([
            editCommentContent.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            editCommentContent.leadingAnchor.constraint(equalTo: editCommentName.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            editCommentContent.bottomAnchor.constraint(equalTo: commentTableView.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
    }
    
    func setEditCommentButton() {
        commentView.addSubview(editCommentButton)
        
        NSLayoutConstraint.activate([
            editCommentButton.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            editCommentButton.leadingAnchor.constraint(equalTo: editCommentContent.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            editCommentButton.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            editCommentButton.bottomAnchor.constraint(equalTo: commentTableView.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        editCommentButton.addTarget(self, action: #selector(tappedEditButton), for: .touchUpInside)
    }
    
    func setCommentTableView() {
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: editCommentContent.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentTableView.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            commentTableView.bottomAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func showToast(message : String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        self.view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            toastView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 10)
        ])
        UIView.animate(withDuration: 2.5, delay: 0.2) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    
    // MARK: @objc
    @objc func tappedLikeButton() {
        let tempSelecetedVideo = !selectedVideo!.favorite
        selectedVideo?.favorite = tempSelecetedVideo
        // save video
        DataManager.shared.tappedLikedButton(selectedVideo!)
        likeButton.setImage(DataManager.shared.getLikedVideoList().filter{ $0.id == selectedVideo?.id }.isEmpty ? UIImage(systemName: "bookmark") : UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
    
    @objc func tappedEditButton() {
        if let content = editCommentContent.text {
            if content == "" {
                // Toast
                showToast(message: "내용을 입력하세요.")
            } else {
                // save comment
                DataManager.shared.createComment(Comment(nickName: "유저 닉네임", content: content, date: Util.util.getDate(), videoId: "비디오 id", userUUId: "유저 id"))

                // 완료 Toast
                showToast(message: "댓글 완료!")
                
                // reload tableView
                commentList.insert(Comment(nickName: "유저 닉네임", content: content, date: Util.util.getDate(), videoId: "비디오 id", userUUId: "유저 id"), at: 0)
                commentTableView.reloadData()
            }
        }
    }
}

// MARK: extension
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.setComment(comment: commentList[indexPath.row])
        return cell
    }
}
