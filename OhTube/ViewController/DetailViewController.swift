//
//  DetailViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    var dummyList = [
        Comment(id: UUID().uuidString, nickName: "1번 이름", content: "1번 내용", date: "1번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
        Comment(id: UUID().uuidString, nickName: "5번 이름", content: "5번 내용", date: "5번 날짜"),
    ]
    
    var profileImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = image.frame.width/2
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.masksToBounds = true
        image.clipsToBounds = true
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
    
    var channelName: UILabel = {
        var label = UILabel()
        label.text = "원훈이와 영식이"
        label.font = Font.contentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewCount: UILabel = {
        var label = UILabel()
        label.text = "15.5만"
        label.font = Font.contentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var uploadDate: UILabel = {
        var label = UILabel()
        label.text = "20시간 전"
        label.font = Font.contentFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likeButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.layer.masksToBounds = false
        btn.layer.cornerRadius = btn.frame.size.width / 2
        btn.clipsToBounds = true
        return btn
    }()
    
    var isLikedButton = false
    
    var commentView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var editCommentName: UITextField = {
        var tf = UITextField()
        tf.placeholder = "닉네임"
        tf.font = Font.commentFont
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        setUI()
    }
    
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
    }
    
    func setTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: profileImage.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        titleLabel.backgroundColor = .systemGray4
    }
    
    func setVideoUView() {
        view.addSubview(videoWebView)
        
        NSLayoutConstraint.activate([
            videoWebView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            //            videoUView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            //            videoUView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            videoWebView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            videoWebView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
//        guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else { return  }
//        videoWebView.loadRequest(URLRequest(url: url))
    }
    
    func setInfoView() {
        view.addSubview(infoView)
        setChannelName()
        setViewCount()
        setUploadDate()
        setLikeButton()
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: videoWebView.bottomAnchor, constant: 10),
            infoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func setChannelName() {
        infoView.addSubview(channelName)
        
        NSLayoutConstraint.activate([
            channelName.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            channelName.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            //            channelName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
        ])
    }
    
    func setViewCount() {
        infoView.addSubview(viewCount)
        
        NSLayoutConstraint.activate([
            viewCount.topAnchor.constraint(equalTo: channelName.bottomAnchor, constant: 10),
            viewCount.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            viewCount.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func setUploadDate() {
        infoView.addSubview(uploadDate)
        
        NSLayoutConstraint.activate([
            uploadDate.topAnchor.constraint(equalTo: viewCount.bottomAnchor, constant: 10),
            uploadDate.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            uploadDate.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            uploadDate.bottomAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    func setLikeButton() {
        infoView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            //            likeButton.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: channelName.trailingAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            //            likeButton.bottomAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            likeButton.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        likeButton.backgroundColor = .cyan
        
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
    }
    
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
        
    }
    
    func setEditCommentContent() {
        commentView.addSubview(editCommentContent)
        
        NSLayoutConstraint.activate([
            editCommentContent.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            editCommentContent.leadingAnchor.constraint(equalTo: editCommentName.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            //            editCommentContent.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
    
    @objc func tappedLikeButton() {
        isLikedButton = !isLikedButton
        likeButton.setImage(isLikedButton ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        // save video
    }
    
    @objc func tappedEditButton() {
        // save comment
        // reload tableView
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.setComment(comment: dummyList[indexPath.row])
        return cell
    }
}
