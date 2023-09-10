//
//  Util.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/06.
//

import UIKit

struct Util {
    static var util = Util()

    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = formatter.string(from: Date())
        return currentDate
    }

    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .systemGray4
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
}

final class ToastView: UILabel {
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
