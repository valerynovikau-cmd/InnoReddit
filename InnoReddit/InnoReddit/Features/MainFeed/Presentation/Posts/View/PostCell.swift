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
    
    private var post: Post?
    private var onPostTap: ((Post) -> Void)?
    
    // MARK: UI elements
    
    // MARK: - Content view
    private func configureContentView() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleContentViewTap))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleContentViewTap() {
        guard let post = self.post else { return }
        self.onPostTap?(post)
    }
    
    // MARK: - Title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: constants.titleLabelFontSize)
        label.numberOfLines = constants.titleLabelNumberOfLines
        return label
    }()
    
    // MARK: - Body label
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = constants.bodyLabelNumberOfLines
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Stack view
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.stackTopBottomPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.stackSidesPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.stackSidesPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constants.stackTopBottomPadding)
        ])
    }
    
    // MARK: - General UI configuration
    private func configureUI() {
        self.configureContentView()
        self.configureStackView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, onPostTap: @escaping ((Post) -> ())) {
        self.post = post
        self.onPostTap = onPostTap
        titleLabel.text = self.post?.title ?? "No title"
        bodyLabel.text = self.post?.text ?? " No text"
    }
}
