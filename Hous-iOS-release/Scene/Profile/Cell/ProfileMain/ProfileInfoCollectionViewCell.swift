//
//  ProfileInfoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/12.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileInfoCollectionViewCell: UICollectionViewCell {

  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileActionControl>()

  // MARK: UI Templetes

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }

  // MARK: UI Components

  private var userName = UILabel().then {
    $0.text = ""
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textAlignment = .left
  }

  private var homie = UILabel().then {
    $0.text = "호미"
    $0.textColor = Colors.g4.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    $0.textAlignment = .left
  }

  private let editButton = UIButton().then {
    $0.setImage(Images.icEditProfile.image, for: .normal)
  }

  private var statusMessage = UILabel().then {
    $0.numberOfLines = 2
    $0.text = ""
    $0.textColor = Colors.g6.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
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

  // MARK: Initializer

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

  // MARK: UI Set

  private func configUI() {
    self.backgroundColor = .white
  }

  private func render() {

    addSubViews([
     userName,
     homie,
     editButton,
     statusMessage,
     tagGuideStackView,
     grayLineView])

    userName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.leading.equalToSuperview().offset(24)
    }

    homie.snp.makeConstraints { make in
      make.centerY.equalTo(userName)
      make.leading.equalTo(userName.snp.trailing).offset(4)
    }

    editButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(28)
      make.trailing.equalToSuperview().offset(-28)
      make.width.height.equalTo(24)
    }

    tagGuideStackView.snp.makeConstraints { make in
      make.top.equalTo(userName.snp.bottom).offset(16)
      make.leading.equalTo(userName)
    }

    statusMessage.snp.makeConstraints { make in
      make.top.equalTo(tagGuideStackView.snp.bottom).offset(13)
      make.leading.equalTo(userName)
      make.trailing.equalToSuperview().offset(-28)
    }

    grayLineView.snp.makeConstraints { make in
      make.top.equalTo(tagGuideStackView.snp.bottom).offset(80.5)
      make.height.equalTo(2)
      make.leading.trailing.equalToSuperview().inset(28)
    }
  }

  private func transferToViewController() {
    self.editButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabEdit)
      }
      .disposed(by: disposeBag)
  }

  func bind(_ data: ProfileModel) {

    self.userName.text = data.userName
    self.statusMessage.text = data.statusMessage ?? "자기소개를 수정해서 룸메이트들에게 나를 소개해보세요!"

    tags = []
    tagGuideStackView.removeFullyAllArrangedSubviews()

    var hashTags: [String] = []

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "MM.dd"

    if data.birthday != nil {
      hashTags.append(String(data.userAge ?? -1) + "세")
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
        $0.text = "아직 정보가 없어요!"
        $0.textColor = Colors.g6.color
        $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
        $0.backgroundColor = .white
        $0.layer.borderColor = Colors.g6.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 13
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
