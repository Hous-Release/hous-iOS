//
//  MateProfileDescriptionInnerCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit
import RxSwift
import RxCocoa

final class MateProfileDescriptionInnerCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var attributeName = UILabel().then {
    $0.text = "성향"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textAlignment = .left
  }
  
  private var attributeDescription = UILabel().then {
    $0.text = "설명"
    $0.numberOfLines = 5
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textAlignment = .left
  }
  
  private var grayLineView = GrayLineView().then {
    $0.backgroundColor = Colors.g1.color
  }
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
   super.prepareForReuse()
   disposeBag = DisposeBag()
 }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
    
    let attrString = NSMutableAttributedString(string: self.attributeDescription.text ?? "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3
    paragraphStyle.alignment = .left
    attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
    
    attributeDescription.attributedText = attrString
  }
  
  private func render() {
    addSubViews([
      attributeName,
      attributeDescription,
      grayLineView])
    
    attributeName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.leading.equalToSuperview().offset(4)
    }
    
    attributeDescription.snp.makeConstraints { make in
      make.top.equalTo(grayLineView.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview()
    }
    
    grayLineView.snp.makeConstraints { make in
      make.top.equalTo(attributeName.snp.bottom).offset(4)
      make.leading.equalToSuperview()
      make.width.equalToSuperview().offset(-15)
      make.height.equalTo(2)
    }
  }
  
  func bind(_ data: PersonalityAttributeDescription) {
    attributeName.text = data.attributeName
    attributeDescription.text = data.attributeDescription
  }
}
