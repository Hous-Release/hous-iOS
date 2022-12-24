//
//  MateProfileInfoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MateProfileInfoCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var statusMessage = UILabel().then {
    $0.numberOfLines = 2
    $0.text = ""
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textAlignment = .left
  }
  
  private var tagGuideStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  private let grayLineView = GrayLineView().then {
    $0.backgroundColor = Colors.g1.color
  }
  
  private var tags: [BasePaddingLabel] = []
  
  private var badgeView = UIImageView().then {
    $0.image = Images.noBadgeProfile.image
  }
  
  private var badgeLabel = UILabel().then {
    $0.text = "뱃지가 없어요"
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    transferToViewController()
  }
  
  //MARK: UI Set
  
  private func configUI() {
    self.backgroundColor = .white
  }
  
  private func render() {
    
    addSubViews([
      statusMessage,
      tagGuideStackView,
      grayLineView,
      badgeView,
      badgeLabel])
    
    tagGuideStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(29)
      make.leading.equalToSuperview().offset(20)
    }
    
    statusMessage.snp.makeConstraints { make in
      make.top.equalTo(tagGuideStackView.snp.bottom).offset(13)
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-135)
    }
    
    grayLineView.snp.makeConstraints { make in
      make.top.equalTo(tagGuideStackView.snp.bottom).offset(80.5)
      make.height.equalTo(2)
      make.leading.trailing.equalToSuperview().inset(28)
    }
    
    badgeView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(29)
      make.trailing.equalToSuperview().offset(-37)
      make.width.height.equalTo(52)
    }
    
    badgeLabel.snp.makeConstraints { make in
      make.top.equalTo(badgeView.snp.bottom).offset(8)
      make.centerX.equalTo(badgeView)
    }
  }
  
  private func transferToViewController() {
  }
  
  func bind(_ data: ProfileModel) {
    
    self.statusMessage.text = data.statusMessage ?? "아직 소개가 작성되지 않았어요!"
    
    let attrString = NSMutableAttributedString(string: self.statusMessage.text ?? "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3
    paragraphStyle.alignment = .left
    attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
    
    statusMessage.attributedText = attrString
    
    if data.badgeImageURL != nil {
      badgeView.kf.setImage(with: URL(string: data.badgeImageURL!))
      badgeLabel.text = data.badgeLabel
    }
    
    tags = []
    tagGuideStackView.removeFullyAllArrangedSubviews()
    
    var hashTags: [String] = []
    
    if data.birthday != nil {
      hashTags.append(String(data.userAge ?? -1) + "세")
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "MM.dd"
    
    if (data.birthdayPublic && data.birthday != nil) {
      hashTags.append(dateFormatter.string(from: data.birthday!))
    }
    
    if let mbti = data.mbti {
      hashTags.append(mbti)
    }
    
    if let userJob = data.userJob {
      hashTags.append(userJob)
    }
    
    if hashTags.count == 0 {
      let tag = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)).then {
        $0.text = "아직 정보가 없어요"
        $0.textColor = .white
        $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
      }
      tags.append(tag)
    } else {
      for item in hashTags {
        let tag = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)).then {
          $0.text = item
          $0.textColor = Colors.g6.color
          $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
          $0.backgroundColor = .white
          $0.layer.borderColor = Colors.g6.color.cgColor
          $0.layer.borderWidth = 1
          $0.layer.cornerRadius = 13
          $0.layer.masksToBounds = true
        }
        tags.append(tag)
      }
    }
    tags.forEach {tagGuideStackView.addArrangedSubview($0)}
  }
}
