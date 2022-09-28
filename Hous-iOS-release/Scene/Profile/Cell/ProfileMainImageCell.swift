//
//  File.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit

final class <#CollectionViewCell#>: UICollectionViewCell {
  
  //MARK: UI Templetes
  
  private enum Size {
    
  }
  
  //MARK: UI Components
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    setData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func render() {
    
  }
  
  func setData() {
    
  }
  
}
