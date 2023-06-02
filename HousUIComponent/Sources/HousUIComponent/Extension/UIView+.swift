import UIKit

public extension UIView {
  @discardableResult
  func makeShadow(color: UIColor,
                  opacity: Float,
                  offset: CGSize,
                  radius: CGFloat) -> Self {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.masksToBounds = false
    return self
  }

  @discardableResult
  func setGradient(colors: [CGColor],
                   locations: [NSNumber] = [0.0, 1.0],
                   startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                   endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)) -> Self {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.colors = colors
    gradient.locations = locations
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.frame = self.bounds
    layer.addSublayer(gradient)
    return self
  }

  func addSubView<T: UIView>(_ subview: T, completionHandler closure: ((T) -> Void)? = nil) {
    addSubview(subview)
    closure?(subview)
  }

  func addSubViews<T: UIView>(_ subviews: [T], completionHandler closure: (([T]) -> Void)? = nil) {
    subviews.forEach { addSubview($0) }
    closure?(subviews)
  }

  /// UIView 의 모서리가 둥근 정도를 설정하는 메서드
  func makeRounded(cornerRadius: CGFloat?) {
    if let cornerRadius = cornerRadius {
      self.layer.cornerRadius = cornerRadius
    } else {
      // cornerRadius 가 nil 일 경우의 default
      self.layer.cornerRadius = self.layer.frame.height / 2
    }

    //      self.clipsToBounds = true
    self.layer.masksToBounds = false
  }

  /// UIView 의 모서리가 둥근 정도를 방향과 함께 설정하는 메서드
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }

  /// UIView의 특정 모서리만 해당 cornerRadius로 설정하는 메서드
  func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
  }
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image(actions: { rendererContext in
      layer.render(in: rendererContext.cgContext)
    })
  }

}
