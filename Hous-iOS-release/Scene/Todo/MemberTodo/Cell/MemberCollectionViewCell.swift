//
//  MemberCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/14.
//

import UIKit
import Then
import ReactorKit

final class MemberCollectionViewCell: UICollectionViewCell, ReactorKit.View {

  var disposeBag = DisposeBag()
  typealias Reactor = MemberCollectionViewCellReactor

  var checkButton = UIButton(configuration: UIButton.Configuration.filled())
  var triangleView = TriangleView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var isSelected: Bool {
    didSet {
      if isSelected {
        triangleView.isHidden = false
        checkButton.isSelected = true
      }
      else {
        triangleView.isHidden = true
        checkButton.isSelected = false
      }
    }
  }
}

extension MemberCollectionViewCell {
  private func setUp() {
    checkButton.configuration?.baseBackgroundColor = Colors.g1.color
    checkButton.configuration?.imagePlacement = .top
    checkButton.configuration?.imagePadding = 8
    checkButton.isUserInteractionEnabled = false
    triangleView.backgroundColor = .clear
    triangleView.isHidden = true
  }

  private func render() {
    addSubViews([checkButton, triangleView])
    checkButton.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    triangleView.snp.makeConstraints { make in
      make.top.equalTo(checkButton.snp.bottom).offset(2)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.size.equalTo(4)
    }
  }
}

extension MemberCollectionViewCell {

  func bind(reactor: MemberCollectionViewCellReactor) {
    let titleAttr: [NSAttributedString.Key: Any] = [
      .font: Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    ]
    checkButton.configuration?.attributedTitle = AttributedString(
      reactor.currentState.userName,
      attributes: AttributeContainer(titleAttr)
    )

    let factory = HomieFactory.makeHomie(type: HomieColor(rawValue: reactor.currentState.color) ?? .GRAY)
    checkButton.configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.image = factory.todoMemberUnchosenImage
        btn.configuration?.baseForegroundColor = Colors.g5.color
      case .selected:
        btn.configuration?.image = factory.todoMemberChosenImage
        btn.configuration?.baseForegroundColor = Colors.black.color
      default:
        break
      }
    }

    layoutSubviews()
  }
}
