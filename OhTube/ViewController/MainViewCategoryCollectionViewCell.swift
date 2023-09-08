//
//  MainViewCategoryCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/07.
//

import UIKit

class MainViewCategoryCollectionViewCell: UICollectionViewCell {
    
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.tintColor = .black
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.5
        label.layer.cornerRadius = 15.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        self.contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            categoryLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            categoryLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            categoryLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        
        ])
    }
}
