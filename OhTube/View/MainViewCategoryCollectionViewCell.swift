//
//  MainViewCategoryCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/07.
//

import UIKit

final class MainViewCategoryCollectionViewCell: UICollectionViewCell {
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.layer.backgroundColor = UIColor.black.cgColor
        label.tintColor = UIColor.black
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.5
        label.layer.cornerRadius = 15.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = nil
    }
    
    private func makeUI() {
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        
        ])
    }
}
