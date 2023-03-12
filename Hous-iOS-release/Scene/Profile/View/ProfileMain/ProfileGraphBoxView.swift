//
//  ProfileGraphBoxView.swift
//  Hous-iOS
//
//  Created by 이의진 on 2022/07/12.
//

import UIKit

final class PersonalityAttribute: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.textColor = Colors.g4.color
    self.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class ProfileGraphBoxView: UIView {

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }

  var profileGraphView = ProfileGraphView()

  private var personalityAttributes: [UILabel] = []

  convenience init(data: ProfileModel) {
    self.init(frame: .zero)
    self.profileGraphView = ProfileGraphView(data: data)
    appendPersonalityAttributesItems()
    configUI()
    render()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI() {
    self.backgroundColor = .white
  }

  private func render() {
    self.addSubView(profileGraphView)

    profileGraphView.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.width.height.equalTo(176)
      make.top.bottom.equalToSuperview().inset(10)
    }

    let labelPositionData: [Double] = [100, 105, 105, 105, 105]
    let labelPosition = makePoint(
      centerPoint: Point(xPos: (Size.screenWidth)/2, yPos: 100),
      dataList: labelPositionData)

    for (index, item) in personalityAttributes.enumerated() {
      self.addSubView(item)
      item.snp.makeConstraints {make in
        make.centerX.equalTo(labelPosition[index].xPos)
        make.centerY.equalTo(labelPosition[index].yPos)
      }
    }
  }

  private func appendPersonalityAttributesItems() {
    let personalityAttributesString = ["빛", "소음", "냄새", "내향", "정리\n정돈"]
    for idx in 0...4 {
      let personalityAttributesItem = PersonalityAttribute()
      personalityAttributesItem.text = personalityAttributesString[idx]
      if idx == 4 {
        personalityAttributesItem.numberOfLines = 2
      }
      personalityAttributes.append(personalityAttributesItem)
    }
  }

  private func makePoint(centerPoint: Point, dataList: [Double]) -> [Point] {
    var points: [Point] = []
    for idx in 0...4 {
      var point = Point(xPos: 0, yPos: 0)
      let angle: Double = Double(idx) * (2/5) * Double.pi
      point.xPos = centerPoint.xPos - dataList[idx] * cos((Double.pi / 2) - angle)
      point.yPos = centerPoint.yPos - dataList[idx] * sin((Double.pi / 2) - angle)
      points.append(point)

    }
    var averageDataPoint: Point = Point(xPos: 0, yPos: 0)
    for point in points {
      averageDataPoint.xPos += (point.xPos - centerPoint.xPos)
      averageDataPoint.yPos += (point.yPos - centerPoint.yPos)
    }
    averageDataPoint.xPos += centerPoint.xPos
    averageDataPoint.yPos += centerPoint.yPos
    points.append(averageDataPoint)
    return points
  }
}
