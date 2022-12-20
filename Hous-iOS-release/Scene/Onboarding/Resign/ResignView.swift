//
//  ResignView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

class ResignView: UIView {

  enum Size {
    static let navigationBarHeight = 64
  }

  let navigationBarView = NavBarWithBackButtonView(title: "회원 탈퇴", rightButtonText: "")

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {

    var layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.scrollDirection = .vertical
    $0.register(cell: ResignGuideCollectionViewCell.self)
    $0.register(cell: ResignInputCollectionViewCell.self)
    $0.showsVerticalScrollIndicator = false
    $0.collectionViewLayout = layout
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ResignView {
  private func render() {
    addSubViews([navigationBarView, collectionView])

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Size.navigationBarHeight)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}
