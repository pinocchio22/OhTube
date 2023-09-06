//
//  ToastView.swift
//  OhTube
//
//  Created by playhong on 2023/09/06.
//

import UIKit

class ToastView: UILabel {
    func configure() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 16)
        self.textAlignment = .center
        self.alpha = 1.0
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.numberOfLines = 2
    }
}
