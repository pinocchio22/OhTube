//
//  MainCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/04.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    
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
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = .black
        title.numberOfLines = 0
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var channelNameLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoViewCountLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoDateLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = .black
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var labelCountstackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoViewCountLabel, videoDateLabel])
        stack.axis = .horizontal
        stack.spacing = 1
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoTitleLabel, channelNameLabel,labelCountstackView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCollectionViewUI()
        cellSetting()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        channelImage.contentMode = .scaleAspectFill
        self.channelImage.layer.cornerRadius = self.channelImage.frame.width / 2
        self.channelImage.clipsToBounds = true
    }
    
    func cellSetting() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    
    func makeCollectionViewUI() {
        self.contentView.addSubview(videoThumbnailImage)
        self.contentView.addSubview(labelCountstackView)
        self.contentView.addSubview(labelsStackView)
        self.contentView.addSubview(channelImage)
        
        
        NSLayoutConstraint.activate([
            videoThumbnailImage.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width),
            videoThumbnailImage.heightAnchor.constraint(equalToConstant: 230),
            videoThumbnailImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            videoThumbnailImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            
            
            channelImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            channelImage.topAnchor.constraint(equalTo: self.videoThumbnailImage.bottomAnchor, constant: 5),
            channelImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            channelImage.widthAnchor.constraint(equalTo: channelImage.heightAnchor),
            channelImage.heightAnchor.constraint(equalTo: channelImage.widthAnchor),
            
            
            labelsStackView.leadingAnchor.constraint(equalTo: channelImage.trailingAnchor, constant: 5),
            labelsStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            labelsStackView.topAnchor.constraint(equalTo: self.channelImage.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: self.channelImage.bottomAnchor),
            
            
            videoTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            channelNameLabel.heightAnchor.constraint(equalToConstant: 14),
            labelCountstackView.heightAnchor.constraint(equalToConstant: 14),
            
            //labelCountstackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -140),
        ])
        
    }
}
