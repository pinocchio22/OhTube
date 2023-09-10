///
//  DetailViewController.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/04.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: variable

    var commentList = DataManager.shared.getCommentList().sorted { $0.date > $1.date }
    var likedVideoList = [Video]()
    var selectedVideo: Video?
    var currentUser = DataManager.shared.getUser()

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
    
    lazy var indicator: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.center = self.view.center
        view.color = .red
        view.style = UIActivityIndicatorView.Style.large
        view.hidesWhenStopped = true
        view.startAnimating()
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
        label.font = Font.mainTitleFont
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
        btn.tintColor = .red
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return btn
    }()
    
    lazy var iconStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [iconLike, iconNext, iconDownload, iconBookmark, iconAdd])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 5
        return sv
    }()
    
    var iconLike: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "like"), for: .normal)
        return btn
    }()
    
    var iconNext: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "next"), for: .normal)
        return btn
    }()
    
    var iconDownload: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "download"), for: .normal)
        return btn
    }()
    
    var iconBookmark: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "bookmark"), for: .normal)
        return btn
    }()
    
    var iconAdd: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "add"), for: .normal)
        return btn
    }()
    
    var commentView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var commentTableView: UITableView = {
        var tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return tv
    }()
    
    var commentCount: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "20개"
        label.font = Font.commentFont
        label.backgroundColor = .systemGray6
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        return label
    }()
    
    var commentSpacer: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    var editCommentName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "닉네임"
        label.font = Font.commentFont
        return label
    }()
    
    var editCommentContent: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "댓글 내용을 입력하세요."
        tf.font = Font.commentFont
        return tf
    }()
    
    var editCommentButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .red
        btn.setImage(UIImage(systemName: "plus.app"), for: .normal)
        return btn
    }()
    
    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        videoWebView.delegate = self
        
        setDetailKeyboardNotification()
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
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.clear.cgColor
        
        profileImage.image = Util.util.imageWith(name: selectedVideo?.channelName)
    }
    
    func setTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: profileImage.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        titleLabel.text = selectedVideo?.channelName
    }
    
    func setVideoUView() {
        view.addSubview(videoWebView)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            videoWebView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            videoWebView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            videoWebView.heightAnchor.constraint(equalToConstant: 250),
        ])

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
        setIconStackView()
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: videoWebView.bottomAnchor, constant: 10),
            infoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            infoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func setVideoTitle() {
        infoView.addSubview(videoTitle)
        
        NSLayoutConstraint.activate([
            videoTitle.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.topAnchor),
            videoTitle.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
        
        videoTitle.text = selectedVideo?.title
    }
    
    func setViewCount() {
        infoView.addSubview(videoDescription)
        infoView.addSubview(viewCount)
        
        NSLayoutConstraint.activate([
            viewCount.topAnchor.constraint(equalTo: videoTitle.bottomAnchor),
            viewCount.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            viewCount.bottomAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.topAnchor, constant: -10),
            viewCount.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        viewCount.text = selectedVideo?.formatViewCount
    }
    
    func setUploadDate() {
        infoView.addSubview(likeButton)
        infoView.addSubview(uploadDate)
        
        NSLayoutConstraint.activate([
            uploadDate.topAnchor.constraint(equalTo: videoTitle.bottomAnchor),
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
            likeButton.bottomAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        likeButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeButton.layer.borderWidth = 1
        likeButton.layer.borderColor = UIColor.black.cgColor
        
        likeButton.setImage(DataManager.shared.getLikedVideoList().filter { $0.id == selectedVideo?.id }.isEmpty ? UIImage(systemName: "bookmark") : UIImage(systemName: "bookmark.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
    }
    
    func setVideoDescription() {
        NSLayoutConstraint.activate([
            videoDescription.leadingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            videoDescription.trailingAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            videoDescription.widthAnchor.constraint(equalTo: infoView.widthAnchor, constant: -10),
        ])
        
        videoDescription.text = selectedVideo?.description
    }
    
    func setIconStackView() {
        infoView.addSubview(iconStackView)
        
        setIconLike()
        setIconNext()
        setIconDownload()
        setIconBookmark()
        setIconAdd()
        
        NSLayoutConstraint.activate([
            iconStackView.topAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            iconStackView.leadingAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            iconStackView.trailingAnchor.constraint(equalTo: videoDescription.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            iconStackView.bottomAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    func setIconLike() {
        NSLayoutConstraint.activate([
            iconLike.widthAnchor.constraint(equalToConstant: 20),
            iconLike.heightAnchor.constraint(equalToConstant: 20),
        ])
        iconLike.addTarget(self, action: #selector(tappedIconLike), for: .touchUpInside)
    }
    
    func setIconNext() {
        NSLayoutConstraint.activate([
            iconNext.widthAnchor.constraint(equalToConstant: 20),
            iconNext.heightAnchor.constraint(equalToConstant: 20),
        ])
        iconNext.addTarget(self, action: #selector(tappedIconNext), for: .touchUpInside)
    }
    
    func setIconDownload() {
        NSLayoutConstraint.activate([
            iconDownload.widthAnchor.constraint(equalToConstant: 20),
            iconDownload.heightAnchor.constraint(equalToConstant: 20),
        ])
        iconDownload.addTarget(self, action: #selector(tappedIconDownload), for: .touchUpInside)
    }
    
    func setIconBookmark() {
        NSLayoutConstraint.activate([
            iconBookmark.widthAnchor.constraint(equalToConstant: 20),
            iconBookmark.heightAnchor.constraint(equalToConstant: 20),
        ])
        iconBookmark.addTarget(self, action: #selector(tappedIconBookmark), for: .touchUpInside)
    }
    
    func setIconAdd() {
        NSLayoutConstraint.activate([
            iconAdd.widthAnchor.constraint(equalToConstant: 20),
            iconAdd.heightAnchor.constraint(equalToConstant: 20),
        ])
        iconAdd.addTarget(self, action: #selector(tappedIconAdd), for: .touchUpInside)
    }
    
    // MARK: commentView

    // set comment group
    func setCommentView() {
        view.addSubview(commentView)
        setCommentTableView()
        setCommentCount()
        setCommentSpacer()
        setEditCommentName()
        setEditCommentContent()
        setEditCommentButton()
        
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: infoView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            commentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            commentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setCommentTableView() {
        commentView.addSubview(commentTableView)
        commentView.addSubview(editCommentName)
        commentView.addSubview(commentSpacer)
        
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentTableView.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            commentTableView.bottomAnchor.constraint(equalTo: commentSpacer.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func setCommentCount() {
        commentView.addSubview(commentCount)
        
        NSLayoutConstraint.activate([
            commentCount.topAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            commentCount.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            commentCount.widthAnchor.constraint(equalToConstant: 50),
            commentCount.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        commentCount.text = "\(commentList.count)개"
    }
    
    func setCommentSpacer() {
        NSLayoutConstraint.activate([
            commentSpacer.topAnchor.constraint(equalTo: commentTableView.safeAreaLayoutGuide.bottomAnchor),
            commentSpacer.leadingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            commentSpacer.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            commentSpacer.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    
    func setEditCommentName() {
        NSLayoutConstraint.activate([
            editCommentName.topAnchor.constraint(equalTo: commentSpacer.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            editCommentName.leadingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            editCommentName.bottomAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            editCommentName.widthAnchor.constraint(equalToConstant: 100),
            editCommentName.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        editCommentName.text = currentUser?.nickName
    }
    
    func setEditCommentContent() {
        commentView.addSubview(editCommentContent)
        
        NSLayoutConstraint.activate([
            editCommentContent.topAnchor.constraint(equalTo: commentSpacer.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            editCommentContent.leadingAnchor.constraint(equalTo: editCommentName.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            editCommentContent.bottomAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        editCommentContent.layer.cornerRadius = 5
        editCommentContent.backgroundColor = .systemGray6
    }
    
    func setEditCommentButton() {
        commentView.addSubview(editCommentButton)
        
        NSLayoutConstraint.activate([
            editCommentButton.topAnchor.constraint(equalTo: commentSpacer.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            editCommentButton.leadingAnchor.constraint(equalTo: editCommentContent.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            editCommentButton.trailingAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            editCommentButton.bottomAnchor.constraint(equalTo: commentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            editCommentButton.widthAnchor.constraint(equalToConstant: 20),
            editCommentButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        editCommentButton.addTarget(self, action: #selector(tappedEditButton), for: .touchUpInside)
    }
    
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure()
        toastView.text = message
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            toastView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
            toastView.heightAnchor.constraint(equalToConstant: view.frame.height / 17),
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
        likeButton.setImage(DataManager.shared.getLikedVideoList().filter { $0.id == selectedVideo?.id }.isEmpty ? UIImage(systemName: "bookmark") : UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
    @objc func tappedIconLike() {
        iconLike.setImage(iconLike.imageView?.image == UIImage(named: "like") ? UIImage(named: "like_red") : UIImage(named: "like"), for: .normal)
    }
    
    @objc func tappedIconNext() {
        iconNext.setImage(iconNext.imageView?.image == UIImage(named: "next") ? UIImage(named: "next_red") : UIImage(named: "next"), for: .normal)
    }
    
    @objc func tappedIconDownload() {
        iconDownload.setImage(iconDownload.imageView?.image == UIImage(named: "download") ? UIImage(named: "download_red") : UIImage(named: "download"), for: .normal)
    }
    
    @objc func tappedIconBookmark() {
        iconBookmark.setImage(iconBookmark.imageView?.image == UIImage(named: "bookmark") ? UIImage(named: "bookmark_red") : UIImage(named: "bookmark"), for: .normal)
    }
    
    @objc func tappedIconAdd() {
        iconAdd.setImage(iconAdd.imageView?.image == UIImage(named: "add") ? UIImage(named: "add_red") : UIImage(named: "add"), for: .normal)
    }
    
    @objc func tappedEditButton() {
        if let content = editCommentContent.text {
            if content == "" {
                // Toast
                showToast(message: "내용을 입력하세요.")
            } else {
                // save comment
                editCommentContent.resignFirstResponder()
                DataManager.shared.createComment(Comment(nickName: currentUser!.nickName, content: content, date: Util.util.getDate(), videoId: selectedVideo!.id, userId: currentUser!.id))

                // 완료 Toast
                showToast(message: "댓글 완료!")
                
                // reload tableView
                commentList.insert(Comment(nickName: currentUser!.nickName, content: content, date: Util.util.getDate(), videoId: selectedVideo!.id, userId: currentUser!.id), at: 0)
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

extension DetailViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicator.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
}
