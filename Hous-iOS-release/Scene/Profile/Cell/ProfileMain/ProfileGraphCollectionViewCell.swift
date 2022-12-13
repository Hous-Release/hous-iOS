//
//  ProfileGraphCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/12.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileGraphCollectionViewCell: UICollectionViewCell {
  
  var disposeBag: DisposeBag = DisposeBag()
  let cellActionControlSubject = PublishSubject<ProfileActionControl>()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
  }
  
  //MARK: UI Components
  
  private var personalityLabel = UILabel().then {
    $0.text = "성향 불러오는 중"
    $0.textColor = .black
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 22)
    $0.textAlignment = .left
  }
  
  private var detailButton = UIButton().then {
    $0.semanticContentAttribute = .forceRightToLeft
    $0.setTitle("성향 설명 보기  ", for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.setTitleColor(Colors.g5.color, for: .normal)
    $0.setImage(Images.icDetailProfile.image, for: .normal)
  }
  
  private var profileGraphBoxView = ProfileGraphBoxView()
  
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
      personalityLabel,
      detailButton])
    
    personalityLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(28)
      make.leading.equalToSuperview().offset(32)
    }
    
    detailButton.snp.makeConstraints { make in
      make.top.equalTo(personalityLabel.snp.top).offset(11)
      make.trailing.equalToSuperview().offset(-32)
      make.width.equalTo(79)
      make.height.equalTo(19)
    }
  }
  
  private func animatedRender() {
    addSubview(profileGraphBoxView)
    
    profileGraphBoxView.snp.makeConstraints { make in
      make.top.equalTo(personalityLabel.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func transferToViewController() {
    self.detailButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.cellActionControlSubject.onNext(.didTabDetail)
      }
      .disposed(by: disposeBag)
  }
  
  func bind(_ data: ProfileModel) {
    // Personality Label
    self.personalityLabel.text = data.personalityColor.personalityText
    self.personalityLabel.textColor = data.personalityColor.textColor
    
    // Graph
    self.profileGraphBoxView = ProfileGraphBoxView(data: data)
    animatedRender()
    self.profileGraphBoxView.profileGraphView.backgroundColor = .white
    self.profileGraphBoxView.profileGraphView.profileGraphBackgroundView.backgroundShapeLayer.fillColor = data.personalityColor.graphBackgroundColor.cgColor
    self.profileGraphBoxView.profileGraphView.profileGraphView.graphShapeLayer.fillColor = data.personalityColor.graphColor.cgColor
    self.profileGraphBoxView.profileGraphView.profileGraphView.dataList = data.typeScores
  }
}
