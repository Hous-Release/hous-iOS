//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import Foundation
import UIKit

public struct BottomSheetModel {
  public let bottomSheetType: BottomSheetType

  public init(bottomSheetType: BottomSheetType) {
    self.bottomSheetType = bottomSheetType
  }
}

public enum BottomSheetType {
  case defaultType
  case todoType([HomieCellModel])
}
