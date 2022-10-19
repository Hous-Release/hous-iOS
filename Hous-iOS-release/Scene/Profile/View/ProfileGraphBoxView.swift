//
//  ProfileGraphBoxView.swift
//  Hous-iOS
//
//  Created by 이의진 on 2022/07/12.
//

import UIKit

final class PersonalityAttribute : UILabel {
  
  override init(frame: CGRect){
    super.init(frame: frame)
    self.textColor = Colors.g4.color
    self.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}

final class ProfileGraphBoxView : UIView {
  
  private enum Size{
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  
  var profileGraphView = ProfileGraphView()
  
  private var personalityAttributes : [UILabel] = []
  
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
  
  private func configUI(){
    self.backgroundColor = .white
  }
  
  private func render(){
    self.addSubViews([profileGraphView])
  
    profileGraphView.snp.makeConstraints {make in
      make.centerX.equalToSuperview()
      make.width.height.equalTo(176)
      make.top.bottom.equalToSuperview().inset(10)
    }
    
    let labelPositionData : [Double] = [100, 105, 105, 105, 105]
    let labelPosition = makePoint(centerPoint: Point(x: (Size.screenWidth)/2, y: 100), dataList: labelPositionData)
    
    for (index, item) in personalityAttributes.enumerated(){
      self.addSubView(item)
      item.snp.makeConstraints {make in
        make.centerX.equalTo(labelPosition[index].x)
        make.centerY.equalTo(labelPosition[index].y)
      }
    }
  }
  
  private func appendPersonalityAttributesItems(){
    let personalityAttributesString = ["빛", "소음", "냄새", "내향", "정리\n정돈"]
    for i in 0...4{
      let personalityAttributesItem = PersonalityAttribute()
      personalityAttributesItem.text = personalityAttributesString[i]
      if i == 4{
        personalityAttributesItem.numberOfLines = 2
      }
      personalityAttributes.append(personalityAttributesItem)
    }
  }
  
  private func makePoint(centerPoint : Point, dataList : [Double]) -> [Point]{
    let pi = Double.pi
    var points : [Point] = []
    for i in 0...4{
      var point = Point(x: 0, y: 0)
      let angle : Double = Double(i) * (2/5) * pi
      point.x = centerPoint.x - dataList[i] * cos((pi / 2) - angle)
      point.y = centerPoint.y - dataList[i] * sin((pi / 2) - angle)
      points.append(point)
      
    }
    var averageDataPoint: Point = Point(x: 0, y: 0)
    for point in points{
      averageDataPoint.x += (point.x - centerPoint.x)
      averageDataPoint.y += (point.y - centerPoint.y)
    }
    averageDataPoint.x += centerPoint.x
    averageDataPoint.y += centerPoint.y
    points.append(averageDataPoint)
    return points
  }
}
