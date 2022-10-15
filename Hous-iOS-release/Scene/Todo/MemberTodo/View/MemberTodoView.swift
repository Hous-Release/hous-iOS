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
  }

  var memberCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.estimatedItemSize = Size.memberItemSize
      $0.collectionViewLayout = layout

      $0.register(cell: MemberCollectionViewCell.self)
    }

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      $0.collectionViewLayout = layout
    }

}
