//
//  UILabel+Extension.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/09.
//  Created by 김민재 on 2022/09/11.
//

import UIKit

enum Device: CGFloat  {
  case IPhone34S = 480.0
  case IPhone5SE = 568.0
  case IPhone6s78 = 667.0
  case IPhone6s78Plus = 736.0
  case IPhoneXXS = 812.0
  case IPhone13 = 844.0
  case IPhoneXR = 896.0
  case IPhone13ProMax = 926.0
  var fontSize: Double {
    switch self {
    case .IPhone34S: return 0.7
    case .IPhone5SE: return 0.8
    case .IPhone6s78: return 0.92
    case .IPhone6s78Plus: return 0.95
    case .IPhoneXXS: return 1
    case .IPhone13: return 1.05
    case .IPhoneXR: return 1.15
    case .IPhone13ProMax: return 1.2
    }
  }
}

extension UILabel {
  
  func addLabelSpacing(kernValue: Double = -0.6, lineSpacing: CGFloat = 4.0) {
    if let labelText = self.text, labelText.count > 0 {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = lineSpacing
      attributedText = NSAttributedString(string: labelText,
                                          attributes: [.kern: kernValue,
                                                       .paragraphStyle: paragraphStyle])
      lineBreakStrategy = .hangulWordPriority
    }
  }
  
  func applyColor(to targetString: String, with color: UIColor) {
    if let labelText = self.text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
      attributedString.addAttribute(.foregroundColor,
                                    value: color,
                                    range: (labelText as NSString).range(of: targetString))
      attributedText = attributedString
    }
  }
  
  func applyFont(to targetString: String, with font: UIFont) {
    if let labelText = self.text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
      attributedString.addAttribute(.font,
                                    value: font,
                                    range: (labelText as NSString).range(of: targetString))
      attributedText = attributedString
    }
  }

  func dynamicFontMontserrat(fontSize size: CGFloat, weight: UIFont.Weight) {
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height
    let fontMultiplier = Device.init(rawValue: height)?.fontSize ?? 1

    switch weight {
    case .bold:
      font = Fonts.Montserrat.bold.font(size: size * fontMultiplier)
    case .semibold:
      font = Fonts.Montserrat.semiBold.font(size: size * fontMultiplier)
    case .medium:
      font = Fonts.Montserrat.medium.font(size: size * fontMultiplier)
    case .regular:
      font = Fonts.Montserrat.regular.font(size: size * fontMultiplier)
    default:
      font = Fonts.Montserrat.medium.font(size: size * fontMultiplier)
    }
  }

  func dynamicFontSpoqaHanSansNeo(fontSize size: CGFloat, weight: UIFont.Weight) {
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height
    let fontMultiplier = Device.init(rawValue: height)?.fontSize ?? 1

    switch weight {
    case .bold:
      font = Fonts.SpoqaHanSansNeo.bold.font(size: size * fontMultiplier)
    case .medium:
      font = Fonts.SpoqaHanSansNeo.medium.font(size: size * fontMultiplier)
    case .regular:
      font = Fonts.SpoqaHanSansNeo.regular.font(size: size * fontMultiplier)
    default:
      font = Fonts.SpoqaHanSansNeo.medium.font(size: size * fontMultiplier)
    }
  }

  func dynamicFont(fontSize size: CGFloat, weight: UIFont.Weight) {
      let currentFontName = self.font.fontName
      var calculatedFont: UIFont?
      let bounds = UIScreen.main.bounds
      let height = bounds.size.height

      switch height {
      case 480.0: //Iphone 3,4S => 3.5 inch
        calculatedFont = UIFont(name: currentFontName, size: size * 0.7)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 568.0: //iphone 5, SE => 4 inch
        calculatedFont = UIFont(name: currentFontName, size: size * 0.8)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
        calculatedFont = UIFont(name: currentFontName, size: size * 0.92)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
        calculatedFont = UIFont(name: currentFontName, size: size * 0.95)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 812.0: //iphone X, XS => 5.8 inch
        calculatedFont = UIFont(name: currentFontName, size: size)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 844.0: // iPhone 13
        calculatedFont = UIFont(name: currentFontName, size: size * 1.05)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
        calculatedFont = UIFont(name: currentFontName, size: size * 1.15)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      case 926.0: // iPhone 13 Pro Max
        calculatedFont = UIFont(name: currentFontName, size: size * 1.2)
        resizeFont(calculatedFont: calculatedFont, weight: weight)
        break
      default:
        print("not an iPhone")
        break
      }
    }

    private func resizeFont(calculatedFont: UIFont?, weight: UIFont.Weight) {
      self.font = calculatedFont
      self.font = UIFont.systemFont(ofSize: calculatedFont!.pointSize, weight: weight)
    }
}
