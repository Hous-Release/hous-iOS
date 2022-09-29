//
//  ProgressBubbleView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit

import SnapKit
import Then

final class ProgressBubbleView: UIView {

  enum Size {
    static let bubbleWidth: CGFloat = 138
    static let bubbleHeight: CGFloat = 29
  }

  var buttonPoint: CGPoint = CGPoint(x: 0, y: 0) {
    didSet {
//      bubbleView.snp.remakeConstraints { make in
//        make.centerX.equalTo(buttonPoint.x - Size.quarterWidthOfBubble)
//        make.centerY.equalTo(buttonPoint.y + 30)
//      }
    }
  }

  let bubbleView = UIView()
  let triangleView = TriangleView()
  private let rectangleView = UIView()

  private let guideLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "아직 하나도 못했어요!"
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 11)
    $0.textColor = Colors.g6.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setUp()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {
    backgroundColor = .clear
    triangleView.color = Colors.g2.color
    triangleView.rotated = true
    triangleView.backgroundColor = .clear
    rectangleView.layer.backgroundColor = Colors.g2.color.cgColor
    rectangleView.makeRounded(cornerRadius: Size.bubbleHeight / 2)
  }

  private func render() {

    addSubview(bubbleView)
    [triangleView, rectangleView].forEach { bubbleView.addSubview($0) }
    rectangleView.addSubView(guideLabel)

    bubbleView.snp.makeConstraints { make in
      make.height.equalTo(Size.bubbleHeight)
      make.width.equalTo(Size.bubbleWidth)
    }

    triangleView.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.size.equalTo(14)
      make.centerY.equalTo(rectangleView.snp.centerY)
    }

    rectangleView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.trailing.equalToSuperview().inset(7)
    }

    guideLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(13)
    }
  }
}
