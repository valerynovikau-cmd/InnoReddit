//
//  PostCellImageView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 27.11.25.
//

import UIKit

final class PostCellImageView: UIView {
    
    weak var delegate: PostCellDelegate?
    
    private let previewImageCornerRadius: CGFloat = 5
    private let pageControlPadding: CGFloat = 8
    
    // MARK: - Images view controllers lifecycle
    private func setupImagesViewController(viewController: UIViewController?) {
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        viewController?.view.layer.cornerRadius = previewImageCornerRadius
        viewController?.view.clipsToBounds = true
        if let view = viewController?.view {
            self.addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
    }
    
    private func tearDownImagesViewController(viewController: UIViewController?) {
        viewController?.willMove(toParent: nil)
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()
    }
    
    // MARK: - (Single image) Post image view controller
    private var imageViewController: PostCellImageViewController?
    
    private func initializePostImageViewController(image: PostImage) {
        guard imageViewController == nil else { return }
        imageViewController = PostCellImageViewController()
        guard let imageViewController else { return }
        let output = PostCellImagePresenter(postImage: image)
        imageViewController.output = output
        output.input = imageViewController
        self.setupImagesViewController(viewController: imageViewController)
    }
    
    private func deinitializePostImageViewController() {
        self.tearDownImagesViewController(viewController: imageViewController)
        imageViewController = nil
    }
    
    private func setupSingleImage(image: PostImage) {
        self.initializePostImageViewController(image: image)
        guard let imageViewController else { return }
        
        delegate?.willShowPostCell(viewController: imageViewController)
        
        imageViewController.view.heightAnchor.constraint(equalTo: imageViewController.view.widthAnchor).isActive = true
    }
    
    // MARK: - (Multiple images) Post images page view controller
    private var postImagesPageViewController: UIPageViewController?
    private var imageControllers: [PostCellImageViewController] = []
    
    private func initializePostImagesPageViewController() {
        guard postImagesPageViewController == nil else { return }
        postImagesPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.setupImagesViewController(viewController: postImagesPageViewController)
        postImagesPageViewController?.dataSource = self
        postImagesPageViewController?.delegate = self
    }
    
    private func deinitializePostImagesPageViewController() {
        postImagesPageViewController?.dataSource = nil
        postImagesPageViewController?.delegate = nil
        self.tearDownImagesViewController(viewController: postImagesPageViewController)
        imageControllers.removeAll()
        postImagesPageViewController = nil
    }
    
    private func setupMultipleImages(images: [PostImage]) {
        imageControllers = images.map({ image in
            let vc = PostCellImageViewController()
            let output = PostCellImagePresenter(postImage: image)
            vc.output = output
            output.input = vc
            return vc
        })
        guard let firstVC = imageControllers.first else { return }
        
        self.initializePostImagesPageViewController()
        
        guard let postImagesPageViewController else { return }
        delegate?.willShowPostCell(viewController: postImagesPageViewController)
        
        self.initializePageControl()
        postImagesPageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
        
        postImagesPageViewController.view.heightAnchor.constraint(equalTo: postImagesPageViewController.view.widthAnchor).isActive = true
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
        
        self.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -pageControlPadding)
        ])
    }
    
    private func deinitializePageControl() {
        pageControl?.removeFromSuperview()
        pageControl = nil
    }
    
    // MARK: - View lifecycle
    public func setup(images: [PostImage]) {
        if images.count == 1 {
            guard let image = images.first else { return }
            self.setupSingleImage(image: image)
        } else {
            self.setupMultipleImages(images: images)
        }
    }
    
    @MainActor deinit {
        if postImagesPageViewController != nil {
            self.deinitializePostImagesPageViewController()
            self.deinitializePageControl()
        }
        
        if imageViewController != nil {
            self.deinitializePostImageViewController()
        }
    }
}

// MARK: - Page view controller data source
extension PostCellImageView: UIPageViewControllerDataSource {
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

// MARK: - Page view controller delegate for updating page control
extension PostCellImageView: UIPageViewControllerDelegate {
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
