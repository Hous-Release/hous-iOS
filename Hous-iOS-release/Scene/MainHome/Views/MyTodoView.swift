//
//  MyTodoView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/24.
//

import UIKit

final class MyTodoView: UIView {

  private let dotView = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }

  private let todoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g7.color
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }

  private lazy var stackView = UIStackView(arrangedSubviews: [dotView, todoLabel]).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 10
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    dotView.layer.cornerRadius = dotView.layer.frame.height / 2
    dotView.layer.masksToBounds = true
  }

  private func configUI() {
    addSubViews([stackView])
    dotView.snp.makeConstraints { make in
      make.size.equalTo(5)
    }
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func setTodoLabels(todo: String) {
    todoLabel.text = todo
  }

  func setTodoLabelFontSize(size: CGFloat) {
    todoLabel.font = Fonts.SpoqaHanSansNeo.medium.font(size: size)
  }

}
