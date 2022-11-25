//
//  TodoHeaderView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/11.
//

import UIKit
import RxSwift

enum TodoMainType: String {
  case myTodo = "My to-do"
  case ourTodo = "Our to-do"
}

final class TodoHeaderCollectionReusableView: UICollectionReusableView {

  var disposeBag = DisposeBag()

  var todoMainType: TodoMainType = .myTodo {
    didSet {
      titleLabel.text = todoMainType.rawValue
      todoMainType == .myTodo ? (infoButton.isHidden = true) : (infoButton.isHidden = false)
    }
  }

  private let titleLabel = UILabel().then {
    $0.text = "My to-do"
    $0.font = Fonts.Montserrat.semiBold.font(size: 20)
    $0.textColor = Colors.black.color
  }

  let todoNumLabel = UILabel().then {
    $0.text = "• 4"
    $0.font = Fonts.Montserrat.semiBold.font(size: 14)
    $0.textColor = Colors.blueL1.color
  }

  let infoButton = UIButton().then {
    $0.setImage(Images.icHelp.image, for: .normal)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {

    [titleLabel, todoNumLabel, infoButton].forEach { addSubview($0) }

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(24)
      make.centerY.equalTo(infoButton.snp.centerY)
    }

    todoNumLabel.snp.makeConstraints { make in
      make.leading.equalTo(titleLabel.snp.trailing).offset(8)
      make.centerY.equalTo(infoButton.snp.centerY)
    }

    infoButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.size.equalTo(40)
      make.trailing.equalToSuperview().inset(24)
    }
  }
}

extension TodoHeaderCollectionReusableView {
  func setHeader(_ type: TodoMainType, _ num: Int) {
    todoMainType = type
    todoNumLabel.text = "• " + String(num)
  }
}
