//
//  PostCell.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 12.11.25.
//

import UIKit
import Kingfisher

protocol PostCellProtocol: AnyObject {
    var output: PostCellPresenterProtocol? { get set }
    func configure()
    
    func onSubredditIconURLRetrieved(subredditIconURL: String?, shouldAnimate: Bool)
    func onCollectionRefreshed()
    func onPostUpdated()
    
    func onPostTap()
    func onUpvoteTap()
    func onDownvoteTap()
    func onCommentTap()
    func onBookmarkTap()
    func onSubredditTap()
}

protocol PostCellDelegate: AnyObject {
    func willShowPostCell(viewController: UIViewController)
    func updatedPost(post: Post)
}

final class PostCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCell"
    var output: PostCellPresenterProtocol?
    weak var delegate: PostCellDelegate?
    
    // MARK: UI elements
    private struct PostCellValues {
        static let outerCornerRadius: CGFloat = 10

        static let subredditImageSize: CGFloat = 24
        static let subredditLabelNumberOfLines: Int = 1
        static let subredditCornerRadius: CGFloat = subredditImageSize / 2
        
        static let dateLabelNumberOfLines: Int = 1
        
        static let titleLabelFontSize: CGFloat = 20
        static let titleLabelNumberOfLines: Int = 0
        
        static let bodyLabelFontSize: CGFloat = 14
        static let bodyLabelNumberOfLines: Int = 3
        
        static let scoreLabelNumberOfLines: Int = 1
        
        static let stackSpacing: CGFloat = 6
        
        static let stackPadding: CGFloat = 12
        static let stackInterSpacing: CGFloat = 8
        
        static let buttonSize: CGFloat = 35
        
        static let bottomLabelsFontSize: CGFloat = 16
        
        static let fadeInAnimationDuration: TimeInterval = 0.1
    }
    
    private enum PostCellButtonType: String {
        case upvote = "arrowshape.up"
        case upvoteVoted = "arrowshape.up.fill"
        case downvote = "arrowshape.down"
        case downvoteVoted = "arrowshape.down.fill"
        case comment = "message"
        case bookmark = "bookmark"
        case bookmarkSaved = "bookmark.fill"
    }

    private typealias constants = PostCellValues
    
    // MARK: - Content view
    private func configureContentView() {
        contentView.backgroundColor = Asset.Assets.Colors.innoSecondaryBackgroundColor.color
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
        imageView.backgroundColor = Asset.Assets.Colors.innoBackgroundColor.color
        imageView.layer.cornerRadius = constants.subredditCornerRadius
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
    private let subredditLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = constants.subredditLabelNumberOfLines
        label.textColor = .secondaryLabel
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Date label
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize)
        label.numberOfLines = constants.dateLabelNumberOfLines
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // MARK: - Top info stack view
    private let topInfoStackView: UIStackView = {
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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.titleLabelFontSize, weight: .bold)
        label.numberOfLines = constants.titleLabelNumberOfLines
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Body label
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize, weight: .regular)
        label.numberOfLines = constants.bodyLabelNumberOfLines
        label.textColor = .label
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Post image view
    private var postImageView: PostCellImageView?
    
    // MARK: - Post content stack view
    private let postContentStackView: UIStackView = {
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
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = constants.scoreLabelNumberOfLines
        label.textAlignment = .center
        label.font = .systemFont(ofSize: constants.bottomLabelsFontSize, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private func configureScoreLabel() {
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
    private let scoreButtonsStackView: UIStackView = {
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
    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    // MARK: - Comment stack
    private let commentStack: UIStackView = {
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
    private let bottomStacksStack: UIStackView = {
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
        self.configureScoreLabel()
        self.configurePostContentStackView()
        
        self.configureCommentStack()
        self.configureScoreButtonsStackView()
        self.configureBottomStacksStack()
        
        for view in self.contentView.subviews { view.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    // MARK: - Cell setup
    private lazy var dateFormatter = RelativeDateTimeFormatter()
    
    private func setupHeaderInfo() {
        guard let post = self.output?.post else { return }
        dateFormatter.dateTimeStyle = .numeric
        let relativeDate = dateFormatter.localizedString(for: post.created, relativeTo: Date())
        dateLabel.text = relativeDate
        
        subredditLabel.text = "r/\(post.subreddit ?? MainScreenStrings.deletedSubreddit)"
    }
    
    private func setupBodyTextInfo() {
        guard let text = self.output?.postSeparatedText else { return }
        if !text.isEmpty {
            postContentStackView.addArrangedSubview(bodyLabel)
            bodyLabel.text = text
        }
        titleLabel.text = self.output?.post.title ?? ""
    }
    
    private func setupPostsImages() {
        guard let images = self.output?.post.images,
              images.count > 0
        else { return }
        
        postImageView = PostCellImageView()
        guard let postImageView else { return }
        
        postImageView.delegate = self.delegate
        postImageView.setup(images: images)
        
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        
        postContentStackView.addArrangedSubview(postImageView)
    }
    
    private func setupBottomButtonsInfo() {
        guard let post = self.output?.post else { return }
        scoreLabel.text = "\(post.score)"
        self.setupScoreButtons()
        self.setupBookmarkButton()
        commentButton.setTitleConfiguration(titleText: "\(post.commentsCount)", fontSize: constants.bottomLabelsFontSize)
    }
    
    private func setupScoreButtons() {
        guard let post = self.output?.post else { return }
        var upvoteSymbolName: String
        var upvoteTintColor: UIColor
        var downVoteSymbolName: String
        var downvoteTintColor: UIColor
        switch post.votedUp {
        case true:
            upvoteSymbolName = PostCellButtonType.upvoteVoted.rawValue
            upvoteTintColor = Asset.Assets.Colors.innoOrangeColor.color
            downVoteSymbolName = PostCellButtonType.downvote.rawValue
            downvoteTintColor = .label
        case false:
            upvoteSymbolName = PostCellButtonType.upvote.rawValue
            upvoteTintColor = .label
            downVoteSymbolName = PostCellButtonType.downvoteVoted.rawValue
            downvoteTintColor = Asset.Assets.Colors.innoOrangeColor.color
        default:
            upvoteSymbolName = PostCellButtonType.upvote.rawValue
            upvoteTintColor = .label
            downVoteSymbolName = PostCellButtonType.downvote.rawValue
            downvoteTintColor = .label
        }
        upvoteButton.setSystemImageConfiguration(systemName: upvoteSymbolName)
        upvoteButton.tintColor = upvoteTintColor
        downvoteButton.setSystemImageConfiguration(systemName: downVoteSymbolName)
        downvoteButton.tintColor = downvoteTintColor
    }
    
    private func setupBookmarkButton() {
        guard let post = self.output?.post else { return }
        var symoblName: String
        var tintColor: UIColor
        if post.saved {
            symoblName = PostCellButtonType.bookmarkSaved.rawValue
            tintColor = Asset.Assets.Colors.innoOrangeColor.color
        } else {
            symoblName = PostCellButtonType.bookmark.rawValue
            tintColor = .label
        }
        bookmarkButton.setSystemImageConfiguration(systemName: symoblName)
        bookmarkButton.tintColor = tintColor
    }
    
    // MARK: - Lifecycle methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subredditImageView.image = nil
        for view in postContentStackView.arrangedSubviews.filter({ [weak self] filteringView in
            filteringView != self?.titleLabel
        }) {
            postContentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        postImageView = nil
    }
    
    @MainActor deinit {
        postImageView = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Post cell view protocol implementation
extension PostCell: PostCellProtocol {
    func onSubredditIconURLRetrieved(subredditIconURL: String?, shouldAnimate: Bool) {
        if let subredditIconURL, !subredditIconURL.isEmpty {
            var options: KingfisherOptionsInfo = []
            if shouldAnimate {
                options.append(.transition(.fade(constants.fadeInAnimationDuration)))
            }
            subredditImageView.kf.setImage(
                with: URL(string: subredditIconURL),
                options: options
            )
        } else {
            self.subredditImageView.image = Asset.Assets.Images.defaultSubredditAvatar.image
            if shouldAnimate {
                subredditImageView.alpha = 0
                UIView.animate(withDuration: constants.fadeInAnimationDuration) { [weak self] in
                    self?.subredditImageView.alpha = 1
                }
            }
        }
    }
    
    func onCollectionRefreshed() {
        self.output?.updatePost()
    }
    
    func onPostUpdated() {
        self.setupBottomButtonsInfo()
        guard let post = self.output?.post else { return }
        self.delegate?.updatedPost(post: post)
    }
    
    func onPostTap() {
        self.output?.onPostTap()
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
    
    func configure() {
        self.setupHeaderInfo()
        self.setupBodyTextInfo()
        self.setupPostsImages()
        self.setupBottomButtonsInfo()
        
        self.output?.retrieveSubredditIconURL()
    }
}
