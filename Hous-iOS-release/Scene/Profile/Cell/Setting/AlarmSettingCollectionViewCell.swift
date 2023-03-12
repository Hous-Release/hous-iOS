//
//  AlarmSettingCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/09.
//

import UIKit
import RxSwift
import RxCocoa

final class AlarmSettingListView: UIView {

  let disposeBag: DisposeBag = DisposeBag()
  let viewActionControlSubject = PublishSubject<ProfileAlarmSettingActionControl>()
  var cellType: AlarmSettingCellType = .none
  var rawValue: Int = -1

  let settingNameLabel = UILabel().then {
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  private let radioButton = UIButton(configuration: .plain())

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
    transferToViewController()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func changeButtonState(isEnable: Bool, isSelected: Bool) {
    var buttonState: AlarmSettingButtonState

    if isSelected {
      buttonState = isEnable ? .enableSelected : .disableSelected
    } else {
      buttonState = .unselected
    }

    switch buttonState {
    case .enableSelected:
      self.radioButton.configuration?.image = Images.icSettingRadioOn.image
      self.radioButton.configuration?.contentInsets = NSDirectionalEdgeInsets(
        top: 15, leading: 20, bottom: 15, trailing: 0)
    case .disableSelected:
      self.radioButton.configuration?.image = Images.icSettingRadioDisable.image
      self.radioButton.configuration?.contentInsets = NSDirectionalEdgeInsets(
        top: 15, leading: 20, bottom: 15, trailing: 0)
    case .unselected:
      self.radioButton.configuration?.image = Images.icSettingRadioOff.image
      self.radioButton.configuration?.contentInsets = NSDirectionalEdgeInsets(
        top: 15, leading: 20, bottom: 15, trailing: 0)
    }
  }

  private func setup() {
    self.backgroundColor = .white
  }

  private func render() {
    addSubViews([settingNameLabel, radioButton])

    settingNameLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }

    radioButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }

  private func transferToViewController() {
    self.radioButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind { [weak self] in
        guard let self = self else { return }
        self.viewActionControlSubject.onNext(.didTabButton(cellType: self.cellType, rawValue: self.rawValue))
      }
      .disposed(by: disposeBag)
  }
}

final class AlarmSettingCollectionViewCell: UICollectionViewCell {

  var cellType: AlarmSettingCellType = .badgeAlarm
  let cellActionControl = PublishSubject<ProfileAlarmSettingActionControl>()
  var disposeBag = DisposeBag()

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  private let grayLineView = UIView().then {
    $0.backgroundColor = Colors.g2.color
  }

  private let cellTitleLabel = UILabel().then {
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
  }

  private let cellSubTitleLabel = UILabel().then {
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }

  private let firstOption = AlarmSettingListView()

  private let secondOption = AlarmSettingListView()

  private lazy var thirdOption = AlarmSettingListView()

  private let settingListStackView = UIStackView().then {
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.axis = .vertical
  }

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
    self.disposeBag = DisposeBag()
    transferToViewController()
  }

  private func configUI() {
    self.backgroundColor = .white
  }

  private func transferToViewController() {
    self.firstOption.viewActionControlSubject
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] data in
        self?.cellActionControl.onNext(data)
      })
      .disposed(by: disposeBag)

    self.secondOption.viewActionControlSubject
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] data in
        self?.cellActionControl.onNext(data)
      })
      .disposed(by: disposeBag)

    switch self.cellType {
    case .newTodo, .todayTodo, .notDoneTodo:
      self.thirdOption.viewActionControlSubject
        .observe(on: MainScheduler.asyncInstance)
        .bind(onNext: { [weak self] data in
          self?.cellActionControl.onNext(data)
        })
        .disposed(by: disposeBag)

    default:
      break
    }

  }

  private func render() {
    self.addSubViews([grayLineView, cellTitleLabel, cellSubTitleLabel, settingListStackView])

    grayLineView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(1)
    }

    cellTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(grayLineView.snp.bottom).offset(19)
      make.leading.equalToSuperview().offset(24)
    }

    cellSubTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(cellTitleLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().offset(24)
    }

    settingListStackView.snp.makeConstraints { make in
      make.top.equalTo(cellSubTitleLabel.snp.bottom).offset(15)
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview()
    }
  }

  func bind(data: AlarmSettingModel, cellType: AlarmSettingCellType) {
    settingListStackView.removeFullyAllArrangedSubviews()
    self.cellType = cellType
    switch cellType {
    case .newRules:
      cellTitleLabel.text = "새로운 Rules 추가"
      cellSubTitleLabel.text = "추가된 우리 집 Rules를 알려줘요!"
      firstOption.settingNameLabel.text = "알림 받기"
      secondOption.settingNameLabel.text = "해제"

      firstOption.changeButtonState(isEnable: data.isPushNotification, isSelected: data.isNewRulesNotification)
      secondOption.changeButtonState(isEnable: data.isPushNotification, isSelected: !data.isNewRulesNotification)

      firstOption.cellType = cellType
      firstOption.rawValue = 0
      secondOption.cellType = cellType
      secondOption.rawValue = 1

      [firstOption, secondOption].forEach {
        settingListStackView.addArrangedSubview($0)
      }

    case .newTodo:
      cellTitleLabel.text = "새로운 to-do 추가"
      cellSubTitleLabel.text = "추가된 My to-do, Our to-do를 알려줘요!"
      firstOption.settingNameLabel.text = "모든 to-do 알림 받기"
      secondOption.settingNameLabel.text = "내가 담당자일 때만 알람 받기"
      thirdOption.settingNameLabel.text = "해제"

      firstOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.newTodoNotification == .allTodo ? true : false)
      secondOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.newTodoNotification == .onlyInCharge ? true : false)
      thirdOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.newTodoNotification == .alarmOff ? true : false)

      firstOption.cellType = cellType
      firstOption.rawValue = 0
      secondOption.cellType = cellType
      secondOption.rawValue = 1
      thirdOption.cellType = cellType
      thirdOption.rawValue = 2

      [firstOption, secondOption, thirdOption].forEach {
        settingListStackView.addArrangedSubview($0)
      }

    case .todayTodo:
      cellTitleLabel.text = "오늘의 to-do 시작"
      cellSubTitleLabel.text = "오늘 해야 할 to-do를 9:00에 알려줘요!"
      firstOption.settingNameLabel.text = "모든 오늘의 to-do 알림 받기"
      secondOption.settingNameLabel.text = "내가 담당자일 때만 알람 받기"
      thirdOption.settingNameLabel.text = "해제"

      firstOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.todayTodoNotification == .allTodo ? true : false)
      secondOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.todayTodoNotification == .onlyInCharge ? true : false)
      thirdOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.todayTodoNotification == .alarmOff ? true : false)

      firstOption.cellType = cellType
      firstOption.rawValue = 0
      secondOption.cellType = cellType
      secondOption.rawValue = 1
      thirdOption.cellType = cellType
      thirdOption.rawValue = 2

      [firstOption, secondOption, thirdOption].forEach {
        settingListStackView.addArrangedSubview($0)
      }

    case .notDoneTodo:
      cellTitleLabel.text = "미완료 to-do"
      cellSubTitleLabel.text = "미완료된 to-do를 22:00에 알려줘요!"
      firstOption.settingNameLabel.text = "모든 미완료 to-do 알림 받기"
      secondOption.settingNameLabel.text = "내가 담당자일 때만 알람 받기"
      thirdOption.settingNameLabel.text = "해제"

      firstOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.notDoneTodoNotification == .allTodo ? true : false)
      secondOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.notDoneTodoNotification == .onlyInCharge ? true : false)
      thirdOption.changeButtonState(
        isEnable: data.isPushNotification, isSelected: data.notDoneTodoNotification == .alarmOff ? true : false)

      firstOption.cellType = cellType
      firstOption.rawValue = 0
      secondOption.cellType = cellType
      secondOption.rawValue = 1
      thirdOption.cellType = cellType
      thirdOption.rawValue = 2

      [firstOption, secondOption, thirdOption].forEach {
        settingListStackView.addArrangedSubview($0)
      }

    case .badgeAlarm:
      cellTitleLabel.text = "배지 알림"
      cellSubTitleLabel.text = "우리 집에서 새로 받은 배지를 알려줘요!"
      firstOption.settingNameLabel.text = "알림 받기"
      secondOption.settingNameLabel.text = "해제"

      firstOption.changeButtonState(isEnable: data.isPushNotification, isSelected: data.isBadgeNotification)
      secondOption.changeButtonState(isEnable: data.isPushNotification, isSelected: !data.isBadgeNotification)

      firstOption.cellType = cellType
      firstOption.rawValue = 0
      secondOption.cellType = cellType
      secondOption.rawValue = 1

      [firstOption, secondOption].forEach {
        settingListStackView.addArrangedSubview($0)
      }

    default:
      break
    }
  }
}
