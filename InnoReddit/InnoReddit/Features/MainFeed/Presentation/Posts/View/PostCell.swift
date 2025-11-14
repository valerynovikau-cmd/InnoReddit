//
//  PostCell.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//


import UIKit

struct PostCellValues {
    static let cornerRadius: CGFloat = 10
    
    static let titleLabelFontSize: CGFloat = 16
    static let titleLabelNumberOfLines: Int = 0
    
    static let bodyLabelFontSize: CGFloat = 14
    static let bodyLabelNumberOfLines: Int = 3
    
    static let stackSpacing: CGFloat = 6
    
    static let stackTopBottomPadding: CGFloat = 8
    static let stackSidesPadding: CGFloat = 12
}

final class PostCell: UICollectionViewCell {
    typealias constants = PostCellValues
    static let reuseIdentifier = "PostCell"
    
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: constants.titleLabelFontSize)
        titleLabel.numberOfLines = constants.titleLabelNumberOfLines
        
        bodyLabel.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        bodyLabel.numberOfLines = constants.bodyLabelNumberOfLines
        bodyLabel.textColor = .secondaryLabel
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.stackTopBottomPadding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.stackSidesPadding),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.stackSidesPadding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constants.stackTopBottomPadding)
        ])
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title ?? ""
        bodyLabel.text = post.text ?? ""
    }
}
