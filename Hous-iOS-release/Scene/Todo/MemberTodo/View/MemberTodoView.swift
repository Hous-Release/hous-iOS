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
    static let memberItemSize = CGSize(width: 50, height: 80)
    static let memberCollectionViewheight = 88
    static let memberCollectionEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
    static let todoListEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 50, right: 0)
    static let floatingButtonSize = 60
  }

  var memberCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.estimatedItemSize = Size.memberItemSize
      layout.sectionInset = Size.memberCollectionEdgeInsets
      $0.collectionViewLayout = layout
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = Colors.g1.color
      $0.register(cell: MemberCollectionViewCell.self)
    }

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout())

  var floatingAddButton = UIButton().then {
    $0.setImage(Images.btnAddFloating.image, for: .normal)
  }

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
    let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

    // MARK: Configure collection view
    todoCollectionView = UICollectionView(frame: bounds, collectionViewLayout: listLayout)
    todoCollectionView.contentInset = Size.todoListEdgeInsets
    todoCollectionView.showsVerticalScrollIndicator = false

  }

  private func render() {
    addSubViews([memberCollectionView, todoCollectionView, floatingAddButton])

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

    floatingAddButton.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview().inset(40)
      make.size.equalTo(Size.floatingButtonSize)
    }
  }
}
