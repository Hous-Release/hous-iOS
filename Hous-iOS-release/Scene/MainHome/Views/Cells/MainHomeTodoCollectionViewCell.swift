//
//  MainHomeTodoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/08.
//

import UIKit

class MainHomeTodoCollectionViewCell: UICollectionViewCell {
  
  //MARK: - Vars & Lets
  static let identifier = "MainHomeTodoCollectionViewCell"
  
  //MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.text = "최인영님의,\n러블리더블리 하우스"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textAlignment = .left
  }
  
  private let editButton = UIButton().then {
    $0.setImage(Images.icEditHous.image, for: .normal)
  }
  
  private let copyButton = UIButton().then {
    $0.setImage(Images.icCopy.image, for: .normal)
  }
  
  private lazy var topButtonStack = UIStackView(arrangedSubviews: [editButton, copyButton]).then {
    $0.spacing = 16
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  private let progressLabel = UILabel().then {
    $0.text = "오늘 우리의 to-do 진행률"
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textAlignment = .left
  }
  
  private let progressView = UIProgressView().then {
    $0.progressTintColor = Colors.blue.color
    $0.trackTintColor = Colors.blueL2.color
    $0.progressViewStyle = .default
    $0.layer.cornerRadius = 8
    $0.progress = 0.5
  }
  
  private let myTodoBackgroundView = UIView().then {
    $0.backgroundColor = Colors.blueL2.color
    $0.layer.cornerRadius = 8
  }
  // TODO: - Todo, Our Rules 이거 어떻게 rx로 넣지????
  private let emptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 내 to-do가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
    $0.textColor = Colors.g5.color
  }
  
  private let dailyLottie = UIView().then {
    $0.backgroundColor = .blue
    $0.layer.cornerRadius = 8
  }
  
  private let todoTitleLabel = UILabel().then {
    $0.text = "MY to-do • 4"
    $0.textColor = Colors.black.color
    $0.font = Fonts.Montserrat.semiBold.font(size: 16)
    $0.textAlignment = .left
  }
  
  private let dotView = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  private let todoLabel = UILabel().then {
    $0.text = "최코코 밥 주기"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g7.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  private lazy var todoLabelStackView = UIStackView(arrangedSubviews: [dotView, todoLabel]).then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.alignment = .center
  }
  
  private let seperatorLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }
  
  private let ourRulesTitleLabel = UILabel().then {
    $0.text = "Our Rules"
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.textAlignment = .left
    $0.textColor = Colors.black.color
  }
  
  private let ourRulesArrowButton = UIButton().then {
    $0.setImage(Images.icMoreOurRules.image, for: .normal)
  }
  
  private let ourRulesBackgroundView = UIView().then {
    $0.backgroundColor = Colors.blueL2.color
    $0.layer.cornerRadius = 8
  }
  
  private let serperatorLineView2 = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }
  
  private let profileTitleLabel = UILabel().then {
    $0.text = "Homies"
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.textColor = Colors.black.color
  }
  
  //MARK: - Life Cycles
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    dotView.layer.cornerRadius = dotView.layer.frame.height / 2
    dotView.layer.masksToBounds = true
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    super.preferredLayoutAttributesFitting(layoutAttributes)
    
    layoutIfNeeded()
    
    let titleHeight = titleLabel.bounds.height
    let progressHeight = progressView.bounds.height
    let todoViewHeight = myTodoBackgroundView.bounds.height
    let ourRuleHeight = ourRulesBackgroundView.bounds.height
    
    var frame = layoutAttributes.frame
    frame.size.height = ceil(titleHeight + progressHeight + todoViewHeight + ourRuleHeight)
    layoutAttributes.frame = frame
    
    return layoutAttributes
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    backgroundColor = .systemBackground
    addSubViews([
      titleLabel,
      topButtonStack,
      progressLabel,
      progressView,
      myTodoBackgroundView,
      dailyLottie,
      seperatorLineView,
      ourRulesTitleLabel,
      ourRulesArrowButton,
      ourRulesBackgroundView,
      serperatorLineView2,
      profileTitleLabel
    ])
    
    myTodoBackgroundView.addSubViews([
      todoTitleLabel,
      todoLabelStackView,
      emptyViewLabel
    ])
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.safeAreaLayoutGuide).offset(28)
      make.leading.equalToSuperview().offset(24)
    }
    
    topButtonStack.snp.makeConstraints { make in
      make.top.equalTo(titleLabel)
      make.trailing.equalToSuperview().inset(32)
    }
    
    progressLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(30)
      make.top.equalTo(titleLabel.snp.bottom).offset(28)
    }
    
    progressView.snp.makeConstraints { make in
      make.top.equalTo(progressLabel.snp.bottom).offset(8)
      make.leading.equalTo(progressLabel)
      make.trailing.equalTo(topButtonStack.snp.trailing)
      make.height.equalTo(8)
    }
    
    myTodoBackgroundView.snp.makeConstraints { make in
      make.top.equalTo(progressView.snp.bottom).offset(16)
      make.leading.equalTo(titleLabel)
      make.width.equalTo(UIScreen.main.bounds.width * (218/375))
      make.height.equalTo(myTodoBackgroundView.snp.width).multipliedBy(0.5733944954)
    }
    
    dailyLottie.snp.makeConstraints { make in
      make.centerY.equalTo(myTodoBackgroundView)
      make.leading.equalTo(myTodoBackgroundView.snp.trailing).offset(12)
      make.trailing.equalToSuperview().inset(24)
      make.bottom.equalTo(myTodoBackgroundView)
    }
    
    todoTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalToSuperview().offset(20)
    }
    
    emptyViewLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(todoTitleLabel.snp.bottom).offset(25)
    }
    
    todoLabelStackView.snp.makeConstraints { make in
      make.top.equalTo(todoTitleLabel.snp.bottom).offset(8)
      make.leading.equalTo(todoTitleLabel)
    }

    dotView.snp.makeConstraints { make in
      make.width.equalTo(5)
      make.height.equalTo(dotView.snp.width)
    }
    
    
    seperatorLineView.snp.makeConstraints { make in
      make.top.equalTo(myTodoBackgroundView.snp.bottom).offset(24)
      make.leading.equalTo(titleLabel)
      make.trailing.equalTo(dailyLottie)
      make.height.equalTo(1)
    }
    
    ourRulesTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(seperatorLineView.snp.bottom).offset(24)
      make.leading.equalTo(progressLabel)
    }
    
    ourRulesArrowButton.snp.makeConstraints { make in
      make.centerY.equalTo(ourRulesTitleLabel)
      make.leading.equalTo(ourRulesTitleLabel.snp.trailing).offset(2)
    }
    
    ourRulesBackgroundView.snp.makeConstraints { make in
      make.top.equalTo(ourRulesTitleLabel.snp.bottom).offset(16)
      make.leading.equalTo(titleLabel)
      make.trailing.equalTo(dailyLottie)
      make.width.equalTo(UIScreen.main.bounds.width * (327/375))
      make.height.equalTo(ourRulesBackgroundView.snp.width).multipliedBy(0.4770642202)
    }
    
    serperatorLineView2.snp.makeConstraints { make in
      make.top.equalTo(ourRulesBackgroundView.snp.bottom).offset(24)
      make.leading.trailing.equalTo(ourRulesBackgroundView)
      make.height.equalTo(1)
    }
    
    profileTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(serperatorLineView2.snp.bottom).offset(24)
      make.leading.equalTo(ourRulesTitleLabel)
    }
  }
}
