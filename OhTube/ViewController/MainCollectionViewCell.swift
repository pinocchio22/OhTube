//
//  MainCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/04.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MainCollectionViewCell"
    
    var videoThumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var channelImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.layer.borderWidth = 2.0 // 테두리 두께 설정
        image.layer.borderColor = UIColor.blue.cgColor // 테두리 색상 설정
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var videoTitleLabel: UILabel = {
        let title = UILabel()
        title.font = Font.mainTitleFont
        title.textColor = .black
        title.numberOfLines = 0
        title.layer.borderWidth = 2.0 // 테두리 두께 설정
        title.layer.borderColor = UIColor.red.cgColor // 테두리 색상 설정
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var channelNameLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.layer.borderWidth = 2.0 // 테두리 두께 설정
        title.layer.borderColor = UIColor.green.cgColor // 테두리 색상 설정
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoViewCountLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.layer.borderWidth = 2.0 // 테두리 두께 설정
        title.layer.borderColor = UIColor.yellow.cgColor // 테두리 색상 설정
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoLikeCountLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.layer.borderWidth = 2.0 // 테두리 두께 설정
        title.layer.borderColor = UIColor.magenta.cgColor // 테두리 색상 설정
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var labelCountstackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [channelNameLabel, videoViewCountLabel, videoLikeCountLabel])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.layer.borderWidth = 2.0 // 테두리 두께 설정
        stack.layer.borderColor = UIColor.purple.cgColor // 테두리 색상 설정
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoTitleLabel, labelCountstackView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
        stack.layer.borderWidth = 2.0 // 테두리 두께 설정
        stack.layer.borderColor = UIColor.systemPink.cgColor // 테두리 색상 설정
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCollectionViewUI()
        cellSetting() // 셀 오토레이아웃 구현한 함수.
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        channelImage.contentMode = .scaleAspectFill
        self.channelImage.layer.cornerRadius = self.channelImage.frame.width / 2
        self.channelImage.clipsToBounds = true
        print(self.channelImage.frame.width)
    }
    
    func cellSetting() {
        self.layer.borderWidth = 1.0 // 테두리 두께
        self.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        self.layer.cornerRadius = 10 // 테두리의 모서리 반경
        self.clipsToBounds = true // 테두리가 뷰 내부에 맞게 잘릴지 여부
    }
    
    
    func makeCollectionViewUI() {
        self.contentView.addSubview(videoThumbnailImage)
        self.contentView.addSubview(labelCountstackView)
        self.contentView.addSubview(labelsStackView)
        self.contentView.addSubview(channelImage)
        
        
        NSLayoutConstraint.activate([
            videoThumbnailImage.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width),
            videoThumbnailImage.heightAnchor.constraint(equalToConstant: 200),
            videoThumbnailImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            
            
            channelImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            channelImage.topAnchor.constraint(equalTo: self.videoThumbnailImage.bottomAnchor, constant: 5),
            channelImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            channelImage.widthAnchor.constraint(equalTo: channelImage.heightAnchor),
            channelImage.heightAnchor.constraint(equalTo: channelImage.widthAnchor),
            
            
            labelsStackView.leadingAnchor.constraint(equalTo: channelImage.trailingAnchor, constant: 5),
            labelsStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            labelsStackView.topAnchor.constraint(equalTo: self.channelImage.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.channelImage.bottomAnchor),
            
            
            videoTitleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
    }
}
