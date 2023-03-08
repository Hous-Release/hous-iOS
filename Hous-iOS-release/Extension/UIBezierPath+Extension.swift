//
//  UIBezierPath+Extension.swift
//  Hous-iOS
//
//  Created by 이의진 on 2022/07/13.
//
import UIKit

public extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = x - point.x
        let yDist = y - point.y
        return (xDist * xDist + yDist * yDist).squareRoot()
    }
}

public func radiusOfCircle(inscribedInto triangle: (pa: CGPoint, pb: CGPoint, pc: CGPoint)) -> CGFloat {
    let (pointa, pointb, pointc) = triangle
    let patha = pointa.distance(to: pointb)
    let pathb = pointb.distance(to: pointc)
    let pathc = pointc.distance(to: pointa)

    let halfP = (patha + pathb + pathc) / 2
    return ((halfP - patha) * (halfP - pathb) * (halfP - pathc) / halfP).squareRoot()
}

extension UIBezierPath {
    private static func addCorner(
        _ path: UIBezierPath,
        point1: CGPoint,
        point: CGPoint,
        point2: CGPoint,
        radius: CGFloat,
        isStart: Bool = false
    ) {
        // Override `radius` with maximum available radius
        // which is the radius of the circle inscribed into triangle defined by our points
        var radius = min(
            radiusOfCircle(inscribedInto: (point1, point, point2)),
            radius
        )

        // Find the angle defined by our points
        let angle = CGFloat(
          atan2(point.y - point1.y, point.x - point1.x) - atan2(point.y - point2.y, point.x - point2.x)
        ).positiveAngle

        // Get the length of segment between angular point and the points of intersection with the circle.
        var tangentLength = radius / abs(tan(angle / 2))

        // Check the length of segment and the minimal length from
        let ptop1 = point.distance(to: point1)
        let ptop2 = point.distance(to: point2)

        // Update `tangentLenghth` according to the smaller triangle side
        tangentLength = min(tangentLength, min(ptop1, ptop2))

        // Update `radius` according to the smaller triangle side
        radius = tangentLength * abs(tan(angle / 2))

        // Find distance from angle vertex to circle origin
        let ptoCircleOrigin = sqrt(radius.sqr + tangentLength.sqr)

        // Segment intersected by parallel lines is divided keeping proportion
        // Project angle sides onto axis and calculate circle origin from the proportion
        let cpoint1 = CGPoint(
            x: (point.x - (point.x - point1.x) * tangentLength / ptop1),
            y: (point.y - (point.y - point1.y) * tangentLength / ptop1)
        )

        let cpoint2 = CGPoint(
            x: (point.x - (point.x - point2.x) * tangentLength / ptop2),
            y: (point.y - (point.y - point2.y) * tangentLength / ptop2)
        )

        let dotx = point.x * 2 - cpoint1.x - cpoint2.x
        let doty = point.y * 2 - cpoint1.y - cpoint2.y

        let ptoc = (dotx.sqr + doty.sqr).squareRoot()

        // Find Circle origin
        let circleOrigin = CGPoint(
            x: point.x - dotx * ptoCircleOrigin / ptoc,
            y: point.y - doty * ptoCircleOrigin / ptoc
        )

        // Find start and end angle (required for Arc drawing)
        let startAngle = (atan2((cpoint1.y - circleOrigin.y), (cpoint1.x - circleOrigin.x))).positiveAngle
        let endAngle = (atan2((cpoint2.y - circleOrigin.y), (cpoint2.x - circleOrigin.x))).positiveAngle

        if isStart {
            path.move(to: cpoint1)
        } else {
            path.addLine(to: cpoint1)
        }

        path.addArc(
          withCenter: circleOrigin, radius: radius,
          startAngle: startAngle, endAngle: endAngle, clockwise: angle < .pi)
    }

    public static func roundedCornersPath(_ pts: [CGPoint], _ radius: CGFloat) -> UIBezierPath? {
        guard pts.isEmpty == false else {
            return nil
        }
        let path = UIBezierPath()
      for pointIdx in 1 ... pts.count {
            let prev = pts[pointIdx-1]
            let curr = pts[pointIdx % pts.count]
            let next = pts[(pointIdx + 1) % pts.count]
        addCorner(path, point1: prev, point: curr, point2: next, radius: radius, isStart: pointIdx == 1)
        }
        path.close()
        return path
    }
}

public extension CGFloat {
    var sqr: CGFloat {
        self * self
    }

    var positiveAngle: CGFloat {
        self < 0
            ? self + 2 * .pi
            : self
    }
}
