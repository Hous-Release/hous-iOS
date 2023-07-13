//
//  File.swift
//  
//
//  Created by 김호세 on 2023/06/02.
//

import AssetKit
import Foundation
import UIKit

/// Hous 폰트 디자인 시스템 - Figma와 제플린에 적혀있습니다.
public enum HousFont {
  case H1
  case H2
  case H3
  case H4
  case B1
  case B2
  case B3
  case description
  case EBT1
  case EBT2
  case EMT1
  case EMT2
  case EMT3
  case EN1
  case EN2
  case DP_b
  case DP_s

  public var font: UIFont {
    switch self {
    case .H1:
      return Fonts.SpoqaHanSansNeo.bold.font(size: 28)
    case .H2:
      return Fonts.SpoqaHanSansNeo.bold.font(size: 22)
    case .H3:
      return Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    case .H4:
      return Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    case .B1:
      return Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    case .B2:
      return Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    case .B3:
      return Fonts.SpoqaHanSansNeo.medium.font(size: 13)
    case .description:
      return Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    case .EBT1:
      return Fonts.Montserrat.bold.font(size: 32)
    case .EBT2:
      return Fonts.Montserrat.bold.font(size: 24)
    case .EMT1:
      return Fonts.Montserrat.semiBold.font(size: 20)
    case .EMT2:
      return Fonts.Montserrat.semiBold.font(size: 18)
    case .EMT3:
      return Fonts.Montserrat.semiBold.font(size: 16)
    case .EN1:
      return Fonts.Montserrat.semiBold.font(size: 14)
    case .EN2:
      return Fonts.Montserrat.medium.font(size: 12)
    case .DP_b:
      return Fonts.Montserrat.semiBold.font(size: 20)
    case .DP_s:
      return Fonts.Montserrat.semiBold.font(size: 18)
    }
  }
}
