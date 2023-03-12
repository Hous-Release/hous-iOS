//
//  GraphBackgroundView.swift
//  Hous-iOS
//
//  Created by 이의진 on 2022/07/13.
//
import UIKit

final class GraphBackgroundView: UIView {
  let graphShapeLayer = CAShapeLayer()
  let graphMaskLayer = CAShapeLayer()
  let backgroundShapeLayer = CAShapeLayer()
  let backgroundMaskLayer = CAShapeLayer()
  var dataList: [Double] = [80, 80, 80, 80, 80]
  var paths: [[CGPoint]] = [[CGPoint()]]

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.paths = self.setUpGraphPaths(dataList)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    backgroundColor = UIColor.clear
    drawBackgroundInitialPath()
  }

  private func drawBackgroundInitialPath() {
    let backgroundPath = UIBezierPath.roundedCornersPath(paths[0], 30)
    backgroundShapeLayer.path = backgroundPath?.cgPath
    backgroundShapeLayer.strokeColor = UIColor.clear.cgColor
    backgroundShapeLayer.fillColor = Colors.redB1.color.cgColor
    layer.addSublayer(backgroundShapeLayer)

    backgroundMaskLayer.path = backgroundShapeLayer.path
    backgroundMaskLayer.position =  backgroundShapeLayer.position
    layer.mask = backgroundMaskLayer
    doAnimationBackground(editing: true, newPath: paths[2])
  }

  func doAnimationBackground(editing: Bool, newPath: [CGPoint]) {
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 1
    // Your new shape here
    let newPath = UIBezierPath.roundedCornersPath(newPath, 30)
    animation.toValue = newPath?.cgPath
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    // The next two line preserves the final shape of animation,
    // if you remove it the shape will return to the original shape after the animation finished
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.isRemovedOnCompletion = false
    backgroundShapeLayer.add(animation, forKey: nil)
    backgroundMaskLayer.add(animation, forKey: nil)
  }

  private func setUpGraphPaths(_ dataList: [Double] ) -> [[CGPoint]] {
    let centerX = Double(self.frame.width)/2
    let centerY = Double(self.frame.height)/2
    let centerPoint = Point(xPos: centerX, yPos: centerY)

    let pointList = makePoint(centerPoint: centerPoint, dataList: dataList)

    let backgroundDataList: [Double] = [90, 90, 90, 90, 90]
    let backgroundPointList = makePoint(centerPoint: centerPoint, dataList: backgroundDataList)

    let graphPath: [CGPoint] = [
      CGPoint(x: pointList[0].xPos, y: pointList[0].yPos),
      CGPoint(x: pointList[1].xPos, y: pointList[1].yPos),
      CGPoint(x: pointList[2].xPos, y: pointList[2].yPos),
      CGPoint(x: pointList[3].xPos, y: pointList[3].yPos),
      CGPoint(x: pointList[4].xPos, y: pointList[4].yPos)
    ]

    let backgroundPath: [CGPoint] = [
      CGPoint(x: backgroundPointList[0].xPos, y: backgroundPointList[0].yPos),
      CGPoint(x: backgroundPointList[1].xPos, y: backgroundPointList[1].yPos),
      CGPoint(x: backgroundPointList[2].xPos, y: backgroundPointList[2].yPos),
      CGPoint(x: backgroundPointList[3].xPos, y: backgroundPointList[3].yPos),
      CGPoint(x: backgroundPointList[4].xPos, y: backgroundPointList[4].yPos)
    ]

    let initialPath: [CGPoint] = [
      CGPoint(x: centerPoint.xPos + 0.001 * pointList[0].xPos, y: centerPoint.yPos + 0.001 * pointList[0].yPos),
      CGPoint(x: centerPoint.xPos + 0.001 * pointList[1].xPos, y: centerPoint.yPos + 0.001 * pointList[1].yPos),
      CGPoint(x: centerPoint.xPos + 0.001 * pointList[2].xPos, y: centerPoint.yPos + 0.001 * pointList[2].yPos),
      CGPoint(x: centerPoint.xPos + 0.001 * pointList[3].xPos, y: centerPoint.yPos + 0.001 * pointList[3].yPos),
      CGPoint(x: centerPoint.xPos + 0.001 * pointList[4].xPos, y: centerPoint.yPos + 0.001 * pointList[4].yPos)
    ]

    let paths = [initialPath, graphPath, backgroundPath]
    return paths
  }

  private func makePoint(centerPoint: Point, dataList: [Double]) -> [Point] {
    var points: [Point] = []
    for idx in 0...4 {
      var point = Point(xPos: 0, yPos: 0)
      let angle: Double = Double(idx) * (2/5) * Double.pi
      point.xPos = centerPoint.xPos - dataList[idx] * cos((Double.pi / 2) + angle)
      point.yPos = centerPoint.yPos - dataList[idx] * sin((Double.pi / 2) + angle)
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
