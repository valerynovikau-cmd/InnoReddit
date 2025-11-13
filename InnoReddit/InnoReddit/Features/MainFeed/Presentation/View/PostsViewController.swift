//
//  PostsViewController.swift
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

class PostsViewController: UIViewController {
    var output: PostsPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post.ID>!
    
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
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
                        
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [footer]
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        collectionView.register(
            IRActivityIndicatorCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: IRActivityIndicatorCollectionViewFooter.identifier
        )
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
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, postIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCell.reuseIdentifier,
                for: indexPath
            ) as? PostCell else { return UICollectionViewCell() }
            
            if let post = self.output?.posts.first(where: { $0.id == postIdentifier }) {
                cell.configure(with: post)
            }
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            guard elementKind == UICollectionView.elementKindSectionFooter else { return nil }
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: IRActivityIndicatorCollectionViewFooter.identifier,
                for: indexPath) as? IRActivityIndicatorCollectionViewFooter
            else {
                return nil
            }
            footer.startAnimating()
            return footer
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post.ID>()
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
        if self.output?.posts.isEmpty ?? false {
            self.output?.preformPostsRetrieval()
        }
    }
}

extension PostsViewController: NavigationBarDisplayable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}

extension PostsViewController: PostsViewProtocol {
    func onPostsUpdated() {
        guard let posts = self.output?.posts else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post.ID>()
        snapshot.appendSections([.main])
        let postIDs = posts.map(\.id)
        snapshot.appendItems(postIDs, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath),
              self.output?.posts.last?.id == id
        else { return }
        self.output?.performPostsPaginatedRetrieval()
    }
}

#Preview {
    ViewControllerPreview {
        let view = PostsViewController()
        return view
    }
    .ignoresSafeArea()
}
