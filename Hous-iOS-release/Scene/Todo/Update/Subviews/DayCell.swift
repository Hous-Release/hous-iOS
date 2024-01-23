//
//  DayCell.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/13.
//

import AssetKit
import UIKit

protocol DidTapDayDelegate: AnyObject {
  func didTapDay(days: [UpdateTodoHomieModel.Day], to id: Int)
}

final class DayCell: UICollectionViewCell {
  private struct Constants {
    static let dayButtonSize: CGSize = CGSize(width: 40, height: 40)
    static let verticalMargin: CGFloat = 12
    static let horizontalMargin: CGFloat = 24
    static let distance: CGFloat = 8
  }

  private let containerView: UIView = {
    let view = UIView()
    return view
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.spacing = Constants.distance

    return stackView
  }()

  weak var delegate: DidTapDayDelegate?
  var onboardingID: Int?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  required init?(coder: NSCoder) {
    fatalError("Not Implemnted")
  }

  func configure(_ model: UpdateTodoHomieModel) {
    self.onboardingID = model.onboardingID
    configureButtonState(model.selectedDay)
  }

  private func configureButtonState(_ days: [UpdateTodoHomieModel.Day]) {
    self.stackView.subviews.forEach { subviews in
      guard let button = subviews as? UIButton else {
        return
      }

      button.isSelected = days.contains(
        where: { $0.description == button.accessibilityIdentifier }
      )
    }
  }

  private func initializeButtonState() {
    self.stackView.subviews.forEach { subview in
      guard let button = subview as? UIButton else {
         return
      }
      button.isSelected = false
    }
  }

  private func makeDayButton(_ day: UpdateTodoHomieModel.Day) -> UIButton {
    let button = UIButton()
    button.setTitle(day.description, for: .normal)
    button.layer.masksToBounds = true
    button.layer.cornerCurve = .circular
    button.layer.cornerRadius = Constants.dayButtonSize.height / 2
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)

    button.accessibilityIdentifier = day.description

    button.setBackgroundColor(Colors.g1.color, for: .normal)
    button.setTitleColor(Colors.g4.color, for: .normal)
    button.setBackgroundColor(Colors.blueL1.color, for: .selected)
    button.setTitleColor(Colors.blue.color, for: .selected)

    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }

  @objc
  private func didTapButton(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected

    guard let id = self.onboardingID else {
      return
    }

    let days = daysState().compactMap { $0 }
    delegate?.didTapDay(days: days, to: id)
  }

  private func daysState() -> [UpdateTodoHomieModel.Day?] {

    var result: [UpdateTodoHomieModel.Day?] = []

    self.stackView.subviews.forEach { view in
      if
        let des = view.accessibilityIdentifier,
        let button = view as? UIButton {
        result.append(button.isSelected ? des.returnDay() : nil )
      }
    }
    return result

  }

  private func setupViews() {
    contentView.backgroundColor = Colors.white.color
    contentView.addSubview(containerView)
    containerView.addSubview(stackView)

    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constants.horizontalMargin)
      make.top.bottom.equalToSuperview().inset(Constants.verticalMargin)
    }

    for day in UpdateTodoHomieModel.Day.allCases {
      let button = makeDayButton(day)
      stackView.addArrangedSubviews(button)

      button.snp.makeConstraints { make in
        make.height.equalTo(button.snp.width).multipliedBy(1)
        make.height.greaterThanOrEqualTo(Constants.dayButtonSize.height)
      }
    }
  }
}
