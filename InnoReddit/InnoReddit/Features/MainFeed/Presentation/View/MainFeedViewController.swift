//
//  MainFeedViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit
import SwiftUI

// MARK: - Section Enum
private enum Section: Int {
    case main
}

class MainFeedViewController: UIViewController {
    var output: MainFeedPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>!
    
    // MARK: UI Elemenets
    
    // MARK: - Root view
    private func configureRootView() {
        view.backgroundColor = Asset.Colors.innoBackgroundColor.color
    }
    
    // MARK: - Collection view
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        return collectionView
    }()
    
    private func configureCollectionView() {
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Diffable Data Source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Post>(
            collectionView: collectionView
        ) { collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCell.reuseIdentifier,
                for: indexPath
            ) as! PostCell
            cell.configure(with: post)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - General view UI configuration
    
    private func configureUI() {
        self.configureRootView()
        self.configureCollectionView()
        self.configureDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.preformHotPostsRetrieval()
    }
}

extension MainFeedViewController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}

extension MainFeedViewController: MainFeedViewProtocol {
    func onHotPostsUpdated() {
        guard let posts = self.output?.hotPosts else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onBestPostsUpdated() {
        
    }
    
    func onNewPostsUpdated() {
        
    }
    
    func onTopPostsUpdated() {
        
    }
    
    func onRisingPostsUpdated() {
        
    }
    
    
}

extension MainFeedViewController: UICollectionViewDelegate { }

#Preview {
    ViewControllerPreview {
        let view = MainFeedViewController()
        return view
    }
    .ignoresSafeArea()
}
