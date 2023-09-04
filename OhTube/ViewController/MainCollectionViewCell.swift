//
//  MainCollectionViewCell.swift
//  OhTube
//
//  Created by 박성원 on 2023/09/04.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "DummyCollectionViewCell"
    
    var nameLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 16)
        name.textColor = .black
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var ageLabel: UILabel = {
        let age = UILabel()
        age.font = .systemFont(ofSize: 14)
        age.textColor = .black
        age.numberOfLines = 0
        age.translatesAutoresizingMaskIntoConstraints = false
        return age
    }()
    
    var addressLabel: UILabel = {
        let address = UILabel()
        address.font = .systemFont(ofSize: 12)
        address.textColor = .black
        address.numberOfLines = 0
        address.translatesAutoresizingMaskIntoConstraints = false
        return address
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, ageLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSetting() // 셀 오토레이아웃 구현한 함수.
        makeCollectionViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cellSetting() {
        self.addSubview(stackView)
        
        self.layer.borderWidth = 1.0 // 테두리 두께
        self.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        self.layer.cornerRadius = 10 // 테두리의 모서리 반경
        self.clipsToBounds = true // 테두리가 뷰 내부에 맞게 잘릴지 여부
    }
    
    
    func makeCollectionViewUI() {
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
}
