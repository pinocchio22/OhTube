//
//  MainCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/04.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    var videoThumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var channelImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 2.0 // 테두리 두께 설정
        image.layer.borderColor = UIColor.systemRed.cgColor // 테두리 색상 설정
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var videoTitleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor.black
        title.backgroundColor = UIColor.clear
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var channelNameLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor.black
        title.numberOfLines = 0
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoViewCountLabel: UILabel = {
        let title = UILabel()
        title.backgroundColor = UIColor.clear
        title.font = Font.contentFont
        title.textColor = UIColor.black
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var videoDateLabel: UILabel = {
        let title = UILabel()
        title.font = Font.contentFont
        title.textColor = UIColor.black
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var labelOfNil: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var labelCountstackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoViewCountLabel, videoDateLabel, labelOfNil])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [videoTitleLabel, channelNameLabel, labelCountstackView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCollectionViewUI()
        cellSetting()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        channelImage.contentMode = .scaleAspectFill
        channelImage.layer.cornerRadius = channelImage.frame.width / 2
        channelImage.clipsToBounds = true
    }
    
    override func prepareForReuse() { 
        super.prepareForReuse()
        videoThumbnailImage.image = nil // UIImage(systemName: "square.and.arrow.up")
        channelImage.image = UIImage(systemName: "square.and.arrow.up")
        videoTitleLabel.text = nil
        channelNameLabel.text = nil
        videoViewCountLabel.text = nil
        videoDateLabel.text = nil
    }
    
    func cellSetting() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    func makeCollectionViewUI() {
        contentView.addSubview(videoThumbnailImage)
        contentView.addSubview(labelCountstackView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(channelImage)
        
        NSLayoutConstraint.activate([
            videoThumbnailImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            videoThumbnailImage.heightAnchor.constraint(equalToConstant: 240),
            videoThumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            videoThumbnailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            
            channelImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            channelImage.topAnchor.constraint(equalTo: videoThumbnailImage.bottomAnchor, constant: 5),
            channelImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            channelImage.widthAnchor.constraint(equalTo: channelImage.heightAnchor),
            channelImage.heightAnchor.constraint(equalTo: channelImage.widthAnchor),
            
            labelsStackView.leadingAnchor.constraint(equalTo: channelImage.trailingAnchor, constant: 5),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            labelsStackView.topAnchor.constraint(equalTo: channelImage.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: channelImage.bottomAnchor),
        
            videoTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            labelCountstackView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
