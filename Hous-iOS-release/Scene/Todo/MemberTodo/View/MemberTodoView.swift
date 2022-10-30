//
//  MemberTodoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/14.
//

import UIKit

import SnapKit
import Then

final class MemberTodoView: UIView {

  enum Size {
    static let memberItemSize = CGSize(width: 80, height: 80)
    static let memberCollectionViewheight = 88
  }

  var memberCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.estimatedItemSize = Size.memberItemSize
      layout.minimumLineSpacing = 0
      $0.collectionViewLayout = layout
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = Colors.g1.color
      $0.register(cell: MemberCollectionViewCell.self)
    }

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout())

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MemberTodoView {

  private func setup() {

    var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
    layoutConfig.backgroundColor = Colors.white.color
    layoutConfig.showsSeparators = false
    layoutConfig.headerTopPadding = 12
    layoutConfig.headerMode = .firstItemInSection
    let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

    // MARK: Configure collection view
    todoCollectionView = UICollectionView(frame: bounds, collectionViewLayout: listLayout)
    todoCollectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 80, right: 0)
    todoCollectionView.showsVerticalScrollIndicator = false

  }

  private func render() {
    addSubViews([memberCollectionView, todoCollectionView])

    memberCollectionView.snp.makeConstraints { make in
      make.height.equalTo(Size.memberCollectionViewheight)
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

    todoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(memberCollectionView.snp.bottom)
      make.bottom.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview().inset(24)
    }
  }
}
