//
//  FilteredButton.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/04.
//

import UIKit
import HousUIComponent

class FilteredButton: UIControl {

  override var isSelected: Bool {
    didSet {

      backgroundColor = isSelected ? Colors.blue.color : Colors.blueL2.color

      [daysOfWeekGuideLabel, homiesGuideLabel].forEach {
        $0.textColor = isSelected ? Colors.blueL1.color : Colors.g6.color
      }

      [daysOfWeekDotImageView, homiesDotImageView].forEach {
        $0.tintColor = isSelected ? Colors.blueL1.color : Colors.blue.color
      }

      [daysOfWeekLabel, homiesLabel].forEach {
        $0.textColor = isSelected ? Colors.white.color : Colors.blue.color
      }
    }
  }

  let stackView: UIStackView = {
    let stack = UIStackView()
    stack.distribution = .fillProportionally
    stack.alignment = .center
    stack.spacing = 4
    return stack
  }()

  let daysOfWeekGuideLabel = HousLabel(
    text: "요일",
    font: .description,
    textColor: Colors.g6.color
  )

  let daysOfWeekDotImageView = UIImageView(
    image: Images.icDotFilter.image
  )

  var daysOfWeekLabel = HousLabel(
    text: "월, 화, 수",
    font: .description,
    textColor: Colors.blue.color
  )

  let lineDefaultImageView = UIImageView(
    image: Images.icLineFilter.image
  )

  let homiesGuideLabel = HousLabel(
    text: "호미",
    font: .description,
    textColor: Colors.g6.color
  )

  let homiesDotImageView = UIImageView(
    image: Images.icDotFilter.image
  )

  var homiesLabel = HousLabel(
    text: "최호미",
    font: .description,
    textColor: Colors.blue.color
  )

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    [daysOfWeekDotImageView, homiesDotImageView].forEach {
      $0.image = $0.image!.withRenderingMode(.alwaysTemplate)
    }
    backgroundColor = Colors.blueL2.color
    makeRounded(cornerRadius: CGFloat(SizeLiterals.FilterButton.height) / 2)
  }

  private func configUI() {

    addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.trailing.leading.equalToSuperview().inset(12)
    }

    stackView.addArrangedSubviews(
      daysOfWeekGuideLabel,
      daysOfWeekDotImageView,
      daysOfWeekLabel,
      lineDefaultImageView,
      homiesGuideLabel,
      homiesDotImageView,
      homiesLabel
    )
  }

}
