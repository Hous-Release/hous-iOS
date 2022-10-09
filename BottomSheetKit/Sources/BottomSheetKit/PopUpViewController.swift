//
//  PopUpViewController.swift
//  
//
//  Created by 김호세 on 2022/10/09.
//

import UIKit
import SnapKit

internal final class PopUpViewController: UIViewController {

  private enum Constant {
    static let horizontalMargin: CGFloat = 40
    static let height: CGFloat = 180
  }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.7)
    return view
  }()

  private var popUpView: UIView
  private let popUpType: PopUpType

  internal init(popUpType: PopUpType) {
    self.popUpType = popUpType

    switch popUpType {
    case .twoButton(let model):
      self.popUpView = TwoButtonPopUpView(model)

    case .oneButtonWithImage(let actionText, let image):
      popUpView = UIView()
      break
    }

    super.init(nibName: nil, bundle: nil)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("PopUpViewController is not implemented")
  }

  private func setupViews() {
    view.addSubview(rootView)
    rootView.addSubview(popUpView)
    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    popUpView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)
      make.centerY.equalToSuperview()

      // TODO: - Change
      make.height.equalTo(180)
    }
  }

}


