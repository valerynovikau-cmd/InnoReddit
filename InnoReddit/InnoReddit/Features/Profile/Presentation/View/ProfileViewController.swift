//
//  ProfileViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import UIKit
import SwiftUI

protocol ProfileViewProtocol: AnyObject {
    var output: ProfilePresenterProtocol? { get set }
    func setPageControllerViewControllers(controllersWithCategoriesStrings: [(UIViewController, String)])
    func scrollCurrentViewControllerToTop()
}

final class ProfileViewController: UIViewController {

    var output: ProfilePresenterProtocol?
    
    // MARK: - UI Elements
    private struct ProfileViewControllerValues {
        static let segmentedControlSidesPadding: CGFloat = 8
        static let pageViewControllerTopPadding: CGFloat = 8
    }
    private typealias constants = ProfileViewControllerValues
    
    // MARK: - Root view
    private func configureRootView() {
        view.backgroundColor = Asset.Assets.Colors.innoBackgroundColor.color
        navigationItem.title = "u/badkrasotka"
    }
    
    // MARK: - Sign out button
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle(ProfileStrings.signOutButtonLabel, for: .normal)
        return button
    }()
    
    private func configureSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: ProfileStrings.signOutButtonLabel,
            style: .plain,
            target: self,
            action: #selector(signOutBarButtonPressed)
        )
    }
    
    @objc private func signOutBarButtonPressed() {
        self.output?.signOut()
    }
    
    // MARK: - ProfileInfo viewController
    private let profileInfoViewController: UIHostingController = {
        let view = ProfileInfoView()
        let vc = UIHostingController(rootView: view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private func configureProfileInfoViewController() {
        addChild(profileInfoViewController)
        view.addSubview(profileInfoViewController.view)
        
        NSLayoutConstraint.activate([
            profileInfoViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileInfoViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constants.segmentedControlSidesPadding),
            profileInfoViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constants.segmentedControlSidesPadding)
        ])
    }
    
    // MARK: - Segmented control
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            ProfileStrings.userPostsTab,
            ProfileStrings.userSavedTab
        ])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: profileInfoViewController.view.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constants.segmentedControlSidesPadding),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constants.segmentedControlSidesPadding)
        ])
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        let newIndex = segmentedControl.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex ? .forward : .reverse
        currentIndex = newIndex
        pageViewController.setViewControllers([controllers[newIndex]], direction: direction, animated: true)
    }
    
    // MARK: - PageViewController
    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    private var currentIndex = 0
    private var controllers: [UIViewController] = []
    
    private func configurePageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: constants.pageViewControllerTopPadding),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - General view UI configuration
    private func configureUI() {
        self.configureRootView()
        self.configureProfileInfoViewController()
        self.configureSegmentedControl()
        self.configurePageViewController()
        self.configureSignOutButton()
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

extension ProfileViewController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        false
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func setPageControllerViewControllers(controllersWithCategoriesStrings: [(UIViewController, String)]) {
        guard controllersWithCategoriesStrings.count > 0 else { return }
        
        self.segmentedControl.removeAllSegments()
        self.controllers = controllersWithCategoriesStrings.enumerated().compactMap { (index, element) in
            self.segmentedControl.insertSegment(withTitle: element.1, at: index, animated: false)
            return element.0
        }
        
        self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: false)
        self.currentIndex = 0
        self.segmentedControl.selectedSegmentIndex = self.currentIndex
    }
    
    func scrollCurrentViewControllerToTop() {
        guard let vc = self.pageViewController.viewControllers?.first as? PostsViewProtocol else { return }
        vc.shouldScrollToTop()
    }
}

extension ProfileViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed, let visibleVC = pageViewController.viewControllers?.first,
           let index = controllers.firstIndex(of: visibleVC) {
            segmentedControl.selectedSegmentIndex = index
            currentIndex = index
        }
    }
}
