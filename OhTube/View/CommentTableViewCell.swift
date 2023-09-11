//
//  CommentTableViewCell.swift
//  OhTube
//
//  Created by t2023-m0056 on 2023/09/05.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var commentName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "닉네임2 / 2023.09.05"
        label.font = Font.commentFont
        return label
    }()
    
    var commentContent: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "댓글 내용"
        label.font = Font.commentFont
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // set comment in tableView
    func setComment(comment: Comment?) {
        guard let comment = comment else {
            return
        }
        commentName.text = "\(comment.nickName) / \(comment.date)"
        commentContent.text = comment.content
    }
    
    func setUI() {
        contentView.addSubview(commentName)
        contentView.addSubview(commentContent)
        
        NSLayoutConstraint.activate([
            commentName.topAnchor.constraint(equalTo: topAnchor),
            commentName.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentName.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            commentContent.topAnchor.constraint(equalTo: commentName.bottomAnchor),
            commentContent.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentContent.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentContent.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
