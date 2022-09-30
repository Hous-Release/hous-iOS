//
//  ProgressBubbleView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit

import SnapKit
import Then

enum BubbleViewType {
  case left, right
}

final class ProgressBubbleView: UIView {

  enum Size {
    static let bubbleWidth: CGFloat = 138
    static let bubbleHeight: CGFloat = 29
  }

  let bubbleView = UIView()
  let triangleView = TriangleView()
  private let rectangleView = UIView()

  var guideLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 11)
    $0.textColor = Colors.g6.color
  }

  init(bubbleViewType: BubbleViewType) {
    super.init(frame: .zero)
    render(bubbleViewType)
    setUp(bubbleViewType)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp(_ bubbleViewType: BubbleViewType) {
    backgroundColor = .clear
    triangleView.color = Colors.g2.color
    triangleView.rotated = true
    triangleView.backgroundColor = .clear
    rectangleView.layer.backgroundColor = Colors.g2.color.cgColor
    rectangleView.makeRounded(cornerRadius: Size.bubbleHeight / 2)
    if bubbleViewType == .right {
      triangleView.transform = CGAffineTransform(rotationAngle: .pi)
    }
  }

  private func render(_ bubbleViewType: BubbleViewType) {

    addSubview(bubbleView)
    [triangleView, rectangleView].forEach { bubbleView.addSubview($0) }
    rectangleView.addSubView(guideLabel)

    bubbleView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    switch bubbleViewType {
    case .left:
      triangleView.snp.makeConstraints { make in
        make.trailing.equalToSuperview()
        make.size.equalTo(14)
        make.centerY.equalTo(rectangleView.snp.centerY)
      }

      rectangleView.snp.makeConstraints { make in
        make.leading.top.bottom.equalToSuperview()
        make.trailing.equalToSuperview().inset(7)
      }
    case .right:
      triangleView.snp.makeConstraints { make in
        make.leading.equalToSuperview()
        make.size.equalTo(14)
        make.centerY.equalTo(rectangleView.snp.centerY)
      }

      rectangleView.snp.makeConstraints { make in
        make.trailing.top.bottom.equalToSuperview()
        make.leading.equalToSuperview().inset(7)
      }
    }

    guideLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(13)
    }
  }
}
