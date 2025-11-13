//
//  MainScreenViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 13.11.25.
//

import UIKit
import Factory

final class MainScreenViewController: UIViewController {
    
    // MARK: UI Elements
    
    // MARK: - Root view
    
    private func configureRootView() {
        view.backgroundColor = Asset.Colors.innoBackgroundColor.color
    }
    
    // MARK: - Search bar
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Segmented control
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Best", "Hot", "New", "Top", "Rising"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private func configureSegmentedControl() {
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
//            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
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
    
    private var pageViewController: UIPageViewController!
    private var controllers: [UIViewController] = []
    private var currentIndex = 0
    
    private func configurePageViewController() {
        // Создаём PageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Создаём контроллеры для каждой вкладки
        controllers = MainFeedCategory.allCases.compactMap {
            let vc = Container.shared.postsView.resolve()
            let presenter = Container.shared.postsPresenter.resolve($0)
            vc.output = presenter
            presenter.input = vc
            return vc as? UIViewController
        }
        
        // Показываем первый
        pageViewController.setViewControllers([controllers[0]], direction: .forward, animated: false)
    }
    
    // MARK: - General view UI configuration
    
    private func configureUI() {
        self.configureRootView()
        self.configureSearchBar()
        self.configureSegmentedControl()
        self.configurePageViewController()
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
}

extension MainScreenViewController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}

extension MainScreenViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first,
           let index = controllers.firstIndex(of: visibleVC) {
            segmentedControl.selectedSegmentIndex = index
            currentIndex = index
        }
    }
}

