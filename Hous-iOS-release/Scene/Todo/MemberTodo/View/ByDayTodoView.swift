//
//  ByDayTodoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

import Then
import SnapKit

class ByDayTodoView: UIView {

  enum Size {
    static let daysOfWeekItemSize = CGSize(width: 40, height: 70)
    static let todoItemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
    static let daysOfWeekCollectionViewHeight = 70
    static let daysOfWeekCollectionEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
  }

  var daysOfWeekCollectionview = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.estimatedItemSize = Size.daysOfWeekItemSize
      layout.sectionInset = Size.daysOfWeekCollectionEdgeInsets
      $0.collectionViewLayout = layout
      $0.showsHorizontalScrollIndicator = false
      $0.backgroundColor = Colors.g1.color
      $0.register(cell: DaysOfWeekCollectionViewCell.self)
    }

  var todoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .vertical
      layout.itemSize = Size.todoItemSize
      $0.collectionViewLayout = layout
      $0.showsVerticalScrollIndicator = false
      $0.register(cell: CountTodoByDayCollectionViewCell.self)
      $0.register(cell: MyTodoByDayCollectionViewCell.self)
      $0.register(cell: OurTodoByDayCollectionViewCell.self)
      $0.register(cell: EmptyTodoByDayCollectionViewCell.self)
      $0.register(
        ByDayHeaderCollectionReusableView.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: ByDayHeaderCollectionReusableView.className)
      $0.register(
        TodoFooterCollectionReusableView.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
        withReuseIdentifier: TodoFooterCollectionReusableView.className)
    }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ByDayTodoView {

  private func render() {
    addSubViews([daysOfWeekCollectionview, todoCollectionView])

    daysOfWeekCollectionview.snp.makeConstraints { make in
      make.height.equalTo(Size.daysOfWeekCollectionViewHeight)
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

    todoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(daysOfWeekCollectionview.snp.bottom)
      make.bottom.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }
  }
}
