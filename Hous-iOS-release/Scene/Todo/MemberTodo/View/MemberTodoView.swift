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
    static let memberItemSize = CGSize(width: 50, height: 100)
    static let memberCollectionViewheight = 64
  }

  var memberCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.estimatedItemSize = Size.memberItemSize
      $0.collectionViewLayout = layout
      $0.backgroundColor = .red
      $0.register(cell: MemberCollectionViewCell.self)
    }

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      $0.collectionViewLayout = layout
      $0.backgroundColor = .red
    }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MemberTodoView {

  private func setUp() {

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
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}
