//
//  ProfileDescriptionInnerCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/14
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileDescriptionInnerCellDelegate: AnyObject {
  
}

final class ProfileDescriptionInnerCollectionViewCell: UICollectionViewCell {
  
  private let disposeBag: DisposeBag = DisposeBag()
  weak var delegate: ProfileDescriptionInnerCellDelegate?
  
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
    $0.numberOfLines = 3
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textAlignment = .left
  }
  
  private var grayLineView = GrayLineView()
  
  
  
  //MARK: Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
    render()
    transferToViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func render() {
    [attributeName, attributeDescription, grayLineView].forEach { addSubview($0) }
    
    attributeName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(5)
      make.leading.equalToSuperview().offset(4)
    }
    
    attributeDescription.snp.makeConstraints { make in
      make.top.equalTo(attributeName.snp.bottom).offset(13)
      make.leading.trailing.equalToSuperview()
      make.width.equalTo(126)
      make.bottom.equalToSuperview()
    }
    
    grayLineView.snp.makeConstraints { make in
      make.top.equalTo(attributeName.snp.bottom).offset(4)
    }
  }
  
  
  private func transferToViewController() {
    
  }
  
  func bind(_ data: PersonalityAttributeDescription) {
    attributeName.text = data.attributeName
    attributeDescription.text = data.attributeDescription
  }
}
