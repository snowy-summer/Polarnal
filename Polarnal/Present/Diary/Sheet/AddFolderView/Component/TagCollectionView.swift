//
//  TagCollectionView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct TagCollectionView: UIViewRepresentable {
    
    @ObservedObject var viewModel: AddFolderViewModel
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = createCollectionViewLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .systemGray6
        
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(4),
                                                         top: .none,
                                                         trailing: .fixed(4),
                                                         bottom: .none)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                        leading: 8,
                                                        bottom: 8,
                                                        trailing: 8)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    final class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        
        private let viewModel: AddFolderViewModel
        
        init(viewModel: AddFolderViewModel) {
            self.viewModel = viewModel
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
            return viewModel.folderTag.count
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier,
                                                                for: indexPath) as? TagCell else {
                return TagCell()
            }
            
            let tag = viewModel.folderTag[indexPath.row]
            cell.updateContent(title: tag.content)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            didSelectItemAt indexPath: IndexPath) {
            viewModel.apply(.deleteTag(indexPath.row))
        }
    }
}

final class TagCell: UICollectionViewCell {
    static let identifier: String = "TagCell"
    
    private let tagTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(tagTitle)
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = #colorLiteral(red: 0.2239803374, green: 0.511967957, blue: 1, alpha: 1)
    }
    
    private func configureLayout() {
        tagTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tagTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            tagTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            tagTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func updateContent(title: String) {
        tagTitle.text = title
    }
}
