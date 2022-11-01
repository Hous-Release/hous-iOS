//
//  TotalTodoNumListCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/01.
//

import UIKit
import Then
import SnapKit

private extension UIConfigurationStateCustomKey {
  static let todoNum = UIConfigurationStateCustomKey("todoNum")
}

extension UIConfigurationState {
  var todoNum: String? {
    get { return self[.todoNum] as? String }
    set { self[.todoNum] = newValue }
  }
}

final class TotalTodoNumListCell: UICollectionViewListCell {
  private var todoNum: String = "0"
  private func defaulTotalNumConfiguration() -> UIListContentConfiguration {
    return .subtitleCell()
  }

  private lazy var totalNumContentView = UIListContentView(configuration: defaulTotalNumConfiguration())

  func update(with newTotalNum: Int) {
    todoNum = String(newTotalNum)
    setNeedsUpdateConfiguration()
  }

  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.todoNum = self.todoNum
    return state
  }

  var todoNumLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 16)
    $0.textColor = Colors.g5.color
  }
}

extension TotalTodoNumListCell {
  func setupViewsIfNeeded() {
    render()
  }

  override func updateConfiguration(using state: UICellConfigurationState) {
    setupViewsIfNeeded()

    var content = defaulTotalNumConfiguration().updated(for: state)
    guard let todoNum = state.todoNum else { return }

    // attributedString
    let fullText = "총 \(todoNum)개"

    let mutableAttributedString = NSMutableAttributedString(string: fullText)
    mutableAttributedString.addAttributes([
      .font: Fonts.SpoqaHanSansNeo.regular.font(size: 16),
      .foregroundColor: Colors.g5.color
    ], range: (fullText as NSString).range(of: fullText))
    mutableAttributedString.addAttributes([
      .font: Fonts.Montserrat.semiBold.font(size: 20),
      .foregroundColor: Colors.blue.color
    ], range: (fullText as NSString).range(of: todoNum))
    content.attributedText = mutableAttributedString
    totalNumContentView.configuration = content
  }
}

extension TotalTodoNumListCell {
  private func render() {
    contentView.addSubview(totalNumContentView)
    totalNumContentView.translatesAutoresizingMaskIntoConstraints = false
    totalNumContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(66)
    }
  }
}
