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
}

protocol PostCellImageCarouselDelegate: AnyObject {
    func willShowPostCell(pageViewController: UIPageViewController)
}

final class PostCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCell"
    var output: PostCellPresenterProtocol?
    weak var delegate: PostCellImageCarouselDelegate?
    
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
        
        static let fadeInAnimationDuration: TimeInterval = 0.1
        
        static let pageControlPadding: CGFloat = 8
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
        label.font = .systemFont(ofSize: constants.titleLabelFontSize, weight: .bold)
        label.numberOfLines = constants.titleLabelNumberOfLines
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Body label
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: constants.bodyLabelFontSize, weight: .regular)
        label.numberOfLines = constants.bodyLabelNumberOfLines
        label.textColor = .label
        label.textAlignment = .natural
        return label
    }()
    
    // MARK: - Post images page view controller
    var postImagesPageViewController: UIPageViewController?
    var imageControllers: [PostCellImageViewController] = []
    
    private func initializePostImagesPageViewController() {
        postImagesPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        postImagesPageViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        postImagesPageViewController?.view.layer.cornerRadius = constants.previewImageCornerRadius
        postImagesPageViewController?.view.clipsToBounds = true
        postImagesPageViewController?.dataSource = self
        postImagesPageViewController?.delegate = self
    }
    
    private func deinitializePostImagesPageViewController() {
        postImagesPageViewController?.view.removeFromSuperview()
        postImagesPageViewController?.removeFromParent()
        postImagesPageViewController = nil
        postImagesPageViewController?.dataSource = nil
        postImagesPageViewController?.delegate = nil
        imageControllers.removeAll()
    }
    
    // MARK: - Page control
    private var pageControl: UIPageControl?
    
    private func initializePageControl() {
        pageControl = UIPageControl()
        guard let pageControl,
              imageControllers.count > 0
        else { return }
        
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = imageControllers.count
        
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: postContentStackView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: postContentStackView.bottomAnchor, constant: -constants.pageControlPadding)
        ])
    }
    
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
    
    private func setupPostsImages() {
        guard let images = self.output?.post.images,
              images.count > 0
        else { return }
        
        initializePostImagesPageViewController()
        
        guard let postImagesPageViewController else { return }
        delegate?.willShowPostCell(pageViewController: postImagesPageViewController)
        
        imageControllers = images.map({ image in
            let vc = PostCellImageViewController()
            let output = PostCellImagePresenter(postImage: image)
            vc.output = output
            output.input = vc
            return vc
        })
        
        initializePageControl()
        
        let firstVC = imageControllers.first ?? UIViewController()
        postImagesPageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
        
        postContentStackView.addArrangedSubview(postImagesPageViewController.view)
        
        NSLayoutConstraint.activate([
            postImagesPageViewController.view.widthAnchor.constraint(equalToConstant: postContentStackView.frame.width),
            postImagesPageViewController.view.heightAnchor.constraint(equalTo: postImagesPageViewController.view.widthAnchor)
        ])
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
        for view in postContentStackView.arrangedSubviews.filter({ [weak self] filteringView in
            filteringView != self?.titleLabel
        }) {
            postContentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        deinitializePostImagesPageViewController()
        pageControl?.removeFromSuperview()
        pageControl = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCell: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? PostCellImageViewController else { return nil }
        guard let index = imageControllers.firstIndex(of: vc), index > 0 else { return nil }
        return imageControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let vc = viewController as? PostCellImageViewController else { return nil }
        guard let index = imageControllers.firstIndex(of: vc), index < imageControllers.count - 1 else { return nil }
        return imageControllers[index + 1]
    }
}

extension PostCell: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let visibleVC = pageViewController.viewControllers?.first as? PostCellImageViewController,
              let index = imageControllers.firstIndex(of: visibleVC) else { return }
        
        pageControl?.currentPage = index
    }
}

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
            self.subredditImageView.image = Asset.Images.defaultSubredditAvatar.image
            if shouldAnimate {
                subredditImageView.alpha = 0
                UIView.animate(withDuration: constants.fadeInAnimationDuration) { [weak self] in
                    self?.subredditImageView.alpha = 1
                }
            }
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
    
    func configure() {
        
        self.setupHeaderInfo()
        self.setupBodyTextInfo()
        self.setupPostsImages()
        self.setupBottomButtonsInfo()
        
        self.output?.retrieveSubredditIconURL()
    }
}
