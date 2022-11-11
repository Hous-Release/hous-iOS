//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import UIKit

public struct HomieCellModel: Hashable {

  public init(
    homieName: String,
    homieColor: UIColor
  ) {
    self.homieName = homieName
    self.homieColor = homieColor
  }

  let homieName: String
  let homieColor: UIColor
}
