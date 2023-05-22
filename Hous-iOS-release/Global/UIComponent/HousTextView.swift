//
//  HousTextView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/22.
//

import UIKit

import RxSwift

final class HousTextView: UIView {

  private let textView = UITextView()
  private let textCountLabel = HousLabel(
    text: "0/50",
    font: Fonts.Montserrat.medium.font(size: 12), textColor: Colors.g5.color)

  private let maxCount: Int
  private let disposeBag = DisposeBag()

  init(maxCount: Int) {
    self.maxCount = maxCount
    super.init(frame: .zero)
    setStyle()
    setLayout()
    setCountLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    self.backgroundColor = Colors.g1.color
    textView.backgroundColor = Colors.g1.color
    textView.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    self.layer.cornerRadius = 8
    self.clipsToBounds = true
  }

  private func setLayout() {
    self.addSubViews([
      textView,
      textCountLabel
    ])

    textView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(12)
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(textCountLabel.snp.top).offset(2)
    }

    textCountLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(5)
      make.trailing.equalToSuperview().inset(12)
    }

  }

  private func setCountLabel() {
    textView.rx.text
      .orEmpty
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { text in
        self.textCountLabel.textColor = Colors.black.color
        self.textCountLabel.text = "\(text.count)/\(self.maxCount)"
        if text.count == 0 || text.count > 50 {
          self.textCountLabel.textColor = Colors.red.color
        }
      })
      .disposed(by: disposeBag)
  }

}
