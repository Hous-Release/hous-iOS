//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import AssetKit
import SnapKit
import UIKit

internal final class DefaultBottomSheetView: UIView {
  private typealias SpoqaHanSansNeo = Fonts.SpoqaHanSansNeo

  private struct Constants {
    static let verticalMargin: CGFloat = 18
    static let horizontalMargin: CGFloat = 24
    static let buttonHeight: CGFloat = 38
  }

  private let rootView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.backgroundColor = .white
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    return view
  }()

  private let handleView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.g3.color
    view.layer.cornerCurve = .continuous
    view.layer.cornerRadius = 5
    return view
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()

    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = Constants.verticalMargin
    stackView.axis = .vertical
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(
      top: Constants.verticalMargin,
      left: Constants.horizontalMargin,
      bottom: Constants.verticalMargin,
      right: Constants.horizontalMargin
    )
    return stackView
  }()

  private let addButton: UIButton = {
    let button = UIButton()
    button.setTitle("추가하기", for: .normal)
    button.setTitleColor(Colors.blue.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    button.titleLabel?.textAlignment = .center
    return button
  }()
  private let modifyButton: UIButton = {
    let button = UIButton()
    button.setTitle("수정하기", for: .normal)
    button.setTitleColor(Colors.black.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    button.titleLabel?.textAlignment = .center
    return button
  }()
  private let deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("추가하기", for: .normal)
    button.setTitleColor(Colors.red.color, for: .normal)
    button.titleLabel?.font = SpoqaHanSansNeo.medium.font(size: 14)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  internal init() {
    super.init(frame: .zero)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("DefaultBottomSheetView is Not Implemented")
  }

  private func setupViews() {
    addSubview(rootView)
    rootView.addSubview(handleView)
    rootView.addSubview(stackView)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    handleView.snp.makeConstraints { make in
      make.width.equalTo(80)
      make.height.equalTo(4)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(Constants.verticalMargin)
    }

    stackView.snp.makeConstraints { make in
      make.top.equalTo(handleView.snp.bottom).offset(Constants.verticalMargin)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(Constants.verticalMargin)
    }

    let l1 = makeG2LineView()
    let l2 = makeG2LineView()

    stackView.addArrangedSubview(addButton)
    stackView.addArrangedSubview(l1)
    stackView.addArrangedSubview(modifyButton)
    stackView.addArrangedSubview(l2)
    stackView.addArrangedSubview(deleteButton)

    [addButton, modifyButton, deleteButton].forEach { button in
      button.snp.makeConstraints { make in
        make.height.equalTo(Constants.buttonHeight)
      }
    }

    [l1, l2].forEach { view in
      view.snp.makeConstraints { make in
        make.height.equalTo(1)
      }
    }
  }

  private func makeG2LineView() -> UIView {
    let view = UIView()
    view.backgroundColor = Colors.g2.color
    return view
  }
}
