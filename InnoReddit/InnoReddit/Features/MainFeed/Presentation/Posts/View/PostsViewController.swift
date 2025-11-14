//
//  PostsViewController.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import UIKit
import SwiftUI

protocol PostsViewProtocol: AnyObject {
    var output: PostsPresenterProtocol? { get set }
    func onPostsUpdated()
}

struct PostsViewControllerValues {
    static let collectionViewInterItemSpacing: CGFloat = 8
    static let collectionViewInterGroupSpacing: CGFloat = 8
    
    static let collectionViewTopPadding: CGFloat = 0
    static let collectionViewBottomPadding: CGFloat = 0
    static let collectionViewSidesPadding: CGFloat = 8
    
    static let collectionViewItemHeightEstimated: CGFloat = 80
    static let collectionViewItemFractionalWidth: CGFloat = 1.0
    
    static let collectionViewFooterHeightEstimated: CGFloat = 50
    static let collectionViewFooterFractionalWidth: CGFloat = 1.0
}

private enum Section: Int {
    case main
}

class PostsViewController: UIViewController {
    typealias constants = PostsViewControllerValues
    
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(constants.collectionViewItemFractionalWidth),
                                                  heightDimension: .estimated(constants.collectionViewItemHeightEstimated))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(constants.collectionViewFooterFractionalWidth),
                heightDimension: .estimated(constants.collectionViewFooterHeightEstimated)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
                        
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [footer]
            section.interGroupSpacing = constants.collectionViewInterGroupSpacing
            section.contentInsets = NSDirectionalEdgeInsets(
                top: constants.collectionViewTopPadding,
                leading: constants.collectionViewSidesPadding,
                bottom: constants.collectionViewBottomPadding,
                trailing: constants.collectionViewSidesPadding
            )
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        collectionView.register(
            IRActivityIndicatorCollectionViewFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: IRActivityIndicatorCollectionViewFooter.reuseIdentifier
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
                withReuseIdentifier: IRActivityIndicatorCollectionViewFooter.reuseIdentifier,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let postIDs = posts.map(\.id)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Post.ID>()
        snapshot.appendSections([.main])
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
