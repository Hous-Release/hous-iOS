//
//  ResignView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

class ResignView: UIView {

  let collectionView = UICollectionView().then {

    var layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.register(cell: ResignGuideCollectionViewCell.self)
    $0.register(cell: MateProfileInfoCollectionViewCell.self)
    $0.showsVerticalScrollIndicator = false
    $0.collectionViewLayout = layout
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ResignView {
  private func render() {

  }

  private func setup() {

  }
}
