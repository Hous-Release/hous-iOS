//
//  RoundedTextFieldWithCount.swift
//  
//
//  Created by 김호세 on 2023/07/02.
//

import AssetKit
import UIKit

/// 둥근 배경이 채워져있는 글자 제한이 있는 텍스트필드 클래스
public final class RoundedTextFieldWithCount: UITextField {

  private struct Constants {
    static let horizontal = 16

  }

  private lazy var maxCountLabel: HousLabel = {
    let label = HousLabel(text: nil, font: .EN2, textColor: Colors.g5.color)
    return label
  }()

  // MARK: - Variable & Properties

  public override var text: String? {
    didSet {
      maxCountLabel.text = "\(self.text?.count ?? 0)/\(maxCount)"
    }
  }

  /// Read - only prop
  public var isValidate: Bool { (text?.count ?? 0) > 0 && (text?.count ?? 0) <= maxCount }

  private let maxCount: Int

  /// Set MaxCount
  public init(
    maxCount: Int
  ) {
    self.maxCount = maxCount
    super.init(frame: .zero)
    setupViews()
    setupStyles()
    registerForNotifications()
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func setupStyles() {
    self.font = HousFont.B2.font
    self.textColor = Colors.black.color
    self.makeRounded(cornerRadius: 8)
    self.backgroundColor = Colors.blueL2.color
  }

  private func setupViews() {
    self.addSubview(maxCountLabel)
    self.addLeftPadding(CGFloat(Constants.horizontal))
    maxCountLabel.text = "\(text?.count ?? 0)/\(maxCount)"

    maxCountLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(Constants.horizontal)
    }
  }

}
extension RoundedTextFieldWithCount {
  @objc
  func change() {
    maxCountLabel.text = "\(self.text?.count ?? 0)/\(maxCount)"
    maxCountLabel.textColor =  isValidate ?  Colors.g5.color : Colors.red.color
  }

  private func registerForNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(change),
      name: .change,
      object: self
    )
  }
}

#if canImport(ThirdPartyLibraryManager)
import RxSwift
import RxCocoa

extension Reactive where Base: RoundedTextFieldWithCount {

  /// Rx Extension - Control Event라서 Bind 할 수 없음. Bind도 하려면 ControlProperty로 수정해야하는데
  /// 그럴만한 이유가 아직 없어서 ControlEvent로 설정
  public var isValidate: ControlEvent<Bool> {
    let source = base.rx.text
      .map { _ in base.isValidate }
      .asObservable()
    return ControlEvent(events: source)
  }
}
#endif
