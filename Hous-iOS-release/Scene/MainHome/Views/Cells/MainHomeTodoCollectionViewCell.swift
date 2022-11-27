//
//  MainHomeTodoCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/08.
//

import UIKit
import RxSwift
import Lottie


class MainHomeTodoCollectionViewCell: UICollectionViewCell {
  
  //MARK: - Vars & Lets
  
  var disposeBag = DisposeBag()
  
  //MARK: - UI Components
  private let titleLabel = UILabel().then {
    $0.dynamicFontSpoqaHanSansNeo(fontSize: 20, weight: .bold)
    $0.numberOfLines = 2
    $0.text = "최인영님의,\n러블리더블리 하우스"
    $0.textColor = Colors.black.color
    $0.textAlignment = .left
  }
  
  let editButton = UIButton().then {
    $0.setImage(Images.icEditHous.image, for: .normal)
  }
  
  let copyButton = UIButton().then {
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
  }
  
  let myTodoBackgroundView = UIView().then {
    $0.backgroundColor = Colors.blueL2.color
    $0.layer.cornerRadius = 8
  }
  
  private let emptyViewLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "아직 내 to-do가 없어요!"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
    $0.textColor = Colors.g5.color
  }
  
  private var dailyLottie = AnimationView().then {
    $0.loopMode = .loop
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }
  
  private let todoTitleLabel = UILabel().then {
    $0.text = "MY to-do"
    $0.textColor = Colors.black.color
    $0.font = Fonts.Montserrat.semiBold.font(size: 16)
    $0.textAlignment = .left
  }
  
  private let todoCountLabel = UILabel().then {
    $0.font = Fonts.Montserrat.semiBold.font(size: 16)
    $0.textColor = Colors.blueL1.color
  }
  
  private let todoView = MyTodoView()
  
  private lazy var todoLabelStackView = UIStackView(arrangedSubviews: [todoView]).then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.alignment = .center
  }
  
  //MARK: - Life Cycles
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Helpers
  func setHomeTodoCell(titleText: String, progress: Float, myTodos: [String], myTodosTotalCount: Int) {
    emptyViewLabel.isHidden = !myTodos.isEmpty
    todoLabelStackView.isHidden = myTodos.isEmpty
    self.titleLabel.text = titleText
    self.progressView.progress = progress
    self.todoCountLabel.text = "• \(myTodosTotalCount)"
    
    todoLabelStackView.subviews.forEach { $0.removeFromSuperview() }
    myTodos.forEach { todoString in
      let label = MyTodoView()
      label.setTodoLabels(todo: todoString)
      todoLabelStackView.addArrangedSubview(label)
    }
  }
  
  //MARK: Configures
  func configUI() {
    backgroundColor = .systemBackground
    addSubViews([
      titleLabel,
      topButtonStack,
      progressLabel,
      progressView,
      myTodoBackgroundView,
      dailyLottie
    ])
    
    myTodoBackgroundView.addSubViews([
      todoTitleLabel,
      todoCountLabel,
      todoLabelStackView,
      emptyViewLabel
    ])
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(28)
      make.leading.equalToSuperview().offset(24)
    }
    
    topButtonStack.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.top)
      make.trailing.equalToSuperview().inset(32)
    }
    
    progressLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel)
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
      make.bottom.equalToSuperview()
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
    
    todoCountLabel.snp.makeConstraints { make in
      make.leading.equalTo(todoTitleLabel.snp.trailing).offset(7)
      make.centerY.equalTo(todoTitleLabel)
    }
    
    emptyViewLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(todoTitleLabel.snp.bottom).offset(25)
    }
    
    todoLabelStackView.snp.makeConstraints { make in
      make.top.equalTo(todoTitleLabel.snp.bottom).offset(8)
      make.leading.equalTo(todoTitleLabel)
    }
  }
  
  func setDailyLottie(day: Weekend) {
    
    dailyLottie.pause()
    switch day {
    case .mon:
      dailyLottie.animation = Animation.named("monday")
    case .tue:
      dailyLottie.animation = Animation.named("tuesday")
    case .wed:
      dailyLottie.animation = Animation.named("wednesday")
    case .thur:
      dailyLottie.animation = Animation.named("thursday")
    case .fri:
      dailyLottie.animation = Animation.named("friday")
    case .sat:
      dailyLottie.animation = Animation.named("weekend")
    case .sun:
      dailyLottie.animation = Animation.named("weekend")
    }
  }
  
  func playLottie() {
    dailyLottie.currentProgress = 0
    dailyLottie.play()
  }
}
