//
//  RulesTableViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/27.
//

import UIKit
import RxSwift

class RulesTableViewCell: UITableViewCell {
  
  private let dotView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }
  
  let selectButton = UIButton().then {
    $0.isHidden = true
    $0.setImage(Images.icDot4.image, for: .normal)
    $0.setImage(Images.icCheck2.image, for: .selected)
  }
  
  private let todoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g7.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    dotView.layer.cornerRadius = dotView.layer.frame.height / 2
    dotView.layer.masksToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  private func configUI() {
    contentView.addSubViews([dotView, selectButton, todoLabel])
    
    dotView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(32)
      make.size.equalTo(8)
    }
    
    selectButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(4)
      make.size.equalTo(44)
    }
    
    todoLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dotView)
      make.leading.equalTo(dotView.snp.trailing).offset(18)
      make.trailing.equalToSuperview().inset(24)
    }
  }
  
  func setLayoutForDeleteRuleView() {
    dotView.isHidden = true
    selectButton.isHidden = false
    
    todoLabel.snp.remakeConstraints { make in
      make.leading.equalTo(selectButton.snp.trailing).offset(10)
      make.centerY.equalTo(selectButton)
    }
    
    todoLabel.textColor = Colors.black.color
  }
  
  func setNormalRulesData(rule: String) {
    todoLabel.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    todoLabel.text = rule
  }
}
