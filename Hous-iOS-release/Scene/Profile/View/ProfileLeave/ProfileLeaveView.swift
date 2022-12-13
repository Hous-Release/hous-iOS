//
//  ProfileLeaveView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit

class ProfileLeaveView: UIView {

  enum Size {
    static let navigationBarHeight = 64
    static let leaveButtonHeight = 44
    static let gradientViewHeight = 143
    static let todoItemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
  }

  let navigationBarView = NavBarWithBackButtonView(title: "방 퇴사하기", rightButtonText: "")

  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()).then {

    var layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
      layout.itemSize = Size.todoItemSize
    $0.register(cell: ProfileLeaveGuideCollectionViewCell.self)
    
    $0.register(cell: CountTodoByDayCollectionViewCell.self)
    $0.register(cell: MyTodoByDayCollectionViewCell.self)
    $0.register(cell: EmptyTodoByDayCollectionViewCell.self)
    $0.register(
      ByDayHeaderCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ByDayHeaderCollectionReusableView.className)
    $0.register(
      TodoFooterCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: TodoFooterCollectionReusableView.className)
    $0.showsVerticalScrollIndicator = false
    $0.collectionViewLayout = layout
  }

  let gradientView = UIImageView().then {
    $0.image = Images.bottomGradient.image
    $0.contentMode = .scaleAspectFill
  }

  let leaveButton = UIButton(configuration: .filled()).then {

    var attrString = AttributedString("회원 탈퇴하기")
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    attrString.foregroundColor = Colors.white.color
    $0.configuration?.attributedTitle = attrString
    $0.configuration?.baseBackgroundColor = Colors.red.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileLeaveView {
  private func render() {
    addSubViews([navigationBarView, collectionView, gradientView, leaveButton])

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Size.navigationBarHeight)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    gradientView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(Size.gradientViewHeight)
    }

    leaveButton.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(24)
      make.height.equalTo(Size.leaveButtonHeight)
      make.bottom.equalToSuperview().inset(40)
    }
  }
}
