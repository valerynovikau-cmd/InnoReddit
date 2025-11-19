//
//  PostCell.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import UIKit
import Kingfisher

protocol PostCellProtocol: AnyObject {
    func configure(output: PostCellPresenterProtocol)
    
    func onSubredditIconURLRetrieved(subredditIconURL: String?)
}

final class PostCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCell"
    var output: PostCellPresenterProtocol?
//    private var post: Post?
    
    // MARK: UI elements
    private struct PostCellValues {
        static let outerCornerRadius: CGFloat = 10
        static let previewImageCornerRadius: CGFloat = 5

        static let subredditImageSize: CGFloat = 24
        
        static let titleLabelFontSize: CGFloat = 20
        static let titleLabelNumberOfLines: Int = 0
        
        static let bodyLabelFontSize: CGFloat = 14
        static let bodyLabelNumberOfLines: Int = 3
        
        static let stackSpacing: CGFloat = 6
        
        static let stackPadding: CGFloat = 12
        static let stackInterSpacing: CGFloat = 8
        
        static let buttonSize: CGFloat = 35
        
        static let bottomLabelsFontSize: CGFloat = 16
    }
    
    private enum PostCellButtonType: String {
        case upvote = "arrow.up"
        case downvote = "arrow.down"
        case comment = "message"
        case bookmark = "bookmark"
    }

    private typealias constants = PostCellValues
    
    // MARK: - Content view
    private func configureContentView() {
        contentView.backgroundColor = Asset.Colors.innoSecondaryBackgroundColor.color
        contentView.layer.cornerRadius = constants.outerCornerRadius
        contentView.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleContentViewTap))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleContentViewTap() {
        self.onPostTap()
    }
    
    // MARK: - Subreddit image
    private lazy var subredditImageView: UIImageView = {
        let imageView = UIImageView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSubredditTap))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.backgroundColor = Asset.Colors.innoBackgroundColor.color
        imageView.layer.cornerRadius = constants.subredditImageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func configureSubredditImageView() {
        NSLayoutConstraint.activate([
            subredditImageView.widthAnchor.constraint(equalToConstant: constants.subredditImageSize),
            subredditImageView.heightAnchor.constraint(equalTo: subredditImageView.widthAnchor)
        ])
    }
    
    @objc private func handleSubredditTap() {
        self.onSubredditTap()
    }
    
    // MARK: - Subreddit label
    private lazy var subredditLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Date label
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // MARK: - Top info stack view
    private lazy var topInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = constants.stackSpacing
        return stack
    }()
    
    private func configureTopInfoStackView() {
        topInfoStackView.addArrangedSubview(subredditImageView)
        topInfoStackView.addArrangedSubview(subredditLabel)
        topInfoStackView.addArrangedSubview(dateLabel)
        contentView.addSubview(topInfoStackView)
        NSLayoutConstraint.activate([
            topInfoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.stackPadding),
            topInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.stackPadding),
            topInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.stackPadding),
        ])
    }
    
    // MARK: - Title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: constants.titleLabelFontSize)
        label.numberOfLines = constants.titleLabelNumberOfLines
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Body label
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = constants.bodyLabelNumberOfLines
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Post image view
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = constants.previewImageCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Post content stack view
    private lazy var postContentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = constants.stackSpacing
        return stack
    }()
    
    private func configurePostContentStackView() {
        postContentStackView.addArrangedSubview(titleLabel)
        contentView.addSubview(postContentStackView)
        NSLayoutConstraint.activate([
            postContentStackView.topAnchor.constraint(equalTo: topInfoStackView.bottomAnchor, constant: constants.stackInterSpacing),
            postContentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.stackPadding),
            postContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.stackPadding),
        ])
    }
    
    // MARK: - Upvote button
    private lazy var upvoteButton: IRPostCellButton = {
        let button = IRPostCellButton(size: constants.buttonSize)
        button.setSystemImageConfiguration(systemName: PostCellButtonType.upvote.rawValue)
        button.addTarget(self, action: #selector(handleUpvoteTap), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleUpvoteTap() {
        self.onUpvoteTap()
    }
    
    // MARK: - Score label
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: constants.bottomLabelsFontSize, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private func scoreLabelConfiguration() {
        scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: constants.buttonSize / 2).isActive = true
    }
    
    // MARK: - Downvote button
    private lazy var downvoteButton: IRPostCellButton = {
        let button = IRPostCellButton(size: constants.buttonSize)
        button.setSystemImageConfiguration(systemName: PostCellButtonType.downvote.rawValue)
        button.addTarget(self, action: #selector(handleDownvoteTap), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleDownvoteTap() {
        self.onDownvoteTap()
    }
    
    // MARK: - Score buttons stack
    private lazy var scoreButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stack
    }()
    
    private func configureScoreButtonsStackView() {
        scoreButtonsStackView.addArrangedSubview(upvoteButton)
        scoreButtonsStackView.addArrangedSubview(scoreLabel)
        scoreButtonsStackView.addArrangedSubview(downvoteButton)
    }
    
    // MARK: - Bookmark button
    private lazy var bookmarkButton: IRPostCellButton = {
        let button = IRPostCellButton(size: constants.buttonSize)
        button.setSystemImageConfiguration(systemName: PostCellButtonType.bookmark.rawValue)
        button.addTarget(self, action: #selector(handleBookmarkTap), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleBookmarkTap() {
        self.onBookmarkTap()
    }
    
    // MARK: - Comment button
    private lazy var commentButton: IRPostCellButton = {
        let button = IRPostCellButton(size: constants.buttonSize)
        button.setSystemImageConfiguration(systemName: PostCellButtonType.comment.rawValue)
        button.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleCommentTap() {
        self.onCommentTap()
    }
    
    // MARK: - Spacer view
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    // MARK: - Comment stack
    private lazy var commentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stack
    }()
    
    private func configureCommentStack() {
        commentStack.addArrangedSubview(commentButton)
        commentStack.addArrangedSubview(spacerView)
        commentStack.addArrangedSubview(bookmarkButton)
    }
    
    // MARK: - Bottom stacks stack
    private lazy var bottomStacksStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = constants.stackSpacing
        return stack
    }()
    
    private func configureBottomStacksStack() {
        bottomStacksStack.addArrangedSubview(scoreButtonsStackView)
        bottomStacksStack.addArrangedSubview(commentStack)
        contentView.addSubview(bottomStacksStack)
        NSLayoutConstraint.activate([
            bottomStacksStack.topAnchor.constraint(equalTo: postContentStackView.bottomAnchor, constant: constants.stackInterSpacing),
            bottomStacksStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.stackPadding),
            bottomStacksStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.stackPadding),
            bottomStacksStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constants.stackInterSpacing)
        ])
    }
    
    // MARK: - General UI configuration
    private func configureUI() {
        self.configureContentView()
        self.configureSubredditImageView()
        self.configureTopInfoStackView()
        self.scoreLabelConfiguration()
        self.configureCommentStack()
        self.configurePostContentStackView()
        self.configureScoreButtonsStackView()
        self.configureBottomStacksStack()
        
        for view in self.contentView.subviews { view.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHeaderInfo() {
        guard let post = self.output?.post else { return }
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.dateTimeStyle = .numeric
        let relativeDate = dateFormatter.localizedString(for: post.created, relativeTo: Date())
        dateLabel.text = relativeDate
        
        subredditLabel.text = "r/\(post.subreddit ?? MainScreenStrings.deletedSubreddit)"
    }
    
    private func setupBodyTextInfo() {
        guard let post = self.output?.post else { return }
        if let text = post.text, !text.isEmpty {
            postContentStackView.addArrangedSubview(bodyLabel)
            bodyLabel.text = text
        }
        titleLabel.text = post.title ?? ""
    }
    
    private func setupBodyImage() {
//        guard let post = self.output?.post else { return }
        postImageView.kf.setImage(
            with: URL(string: "https://opis-cdn.tinkoffjournal.ru/mercury/03-skebob.png"),
            options: [
                .processor(RoundCornerImageProcessor(cornerRadius: constants.previewImageCornerRadius)),
                .transition(.fade(0.1)),
                .forceTransition
            ]
        )
        postContentStackView.addArrangedSubview(postImageView)
        postImageView.heightAnchor.constraint(equalTo: postContentStackView.widthAnchor).isActive = true
    }
    
    private func setupBottomButtonsInfo() {
        guard let post = self.output?.post else { return }
        scoreLabel.text = "\(post.score)"
        commentButton.setTitleConfiguration(titleText: "\(post.commentsCount)", fontSize: constants.bottomLabelsFontSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subredditImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCell: PostCellProtocol {
    func onSubredditIconURLRetrieved(subredditIconURL: String?) {
        if let subredditIconURL, !subredditIconURL.isEmpty {
            subredditImageView.kf.setImage(
                with: URL(string: subredditIconURL),
                options: [
                    .transition(.fade(0.1))
                ]
            )
        } else {
            subredditImageView.image = Asset.Images.defaultSubredditAvatar.image
        }
    }
    
    func onPostTap() {
        
    }
    
    func onUpvoteTap() {
        
    }
    
    func onDownvoteTap() {
        
    }
    
    func onCommentTap() {
        
    }
    
    func onBookmarkTap() {
        
    }
    
    func onSubredditTap() {
        
    }
    
    func configure(output: PostCellPresenterProtocol) {
        self.output = output
        
        self.setupHeaderInfo()
        self.setupBodyTextInfo()
        self.setupBodyImage()
        self.setupBottomButtonsInfo()
        
        self.output?.retrieveSubredditIconURL()
    }
}
