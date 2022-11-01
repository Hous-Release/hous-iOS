//
//  DayOfWeekHeaderListCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/30.
//

import UIKit
import Network

private extension UIConfigurationStateCustomKey {
  static let dayOfWeek = UIConfigurationStateCustomKey("dayOfWeek")
}

extension UIConfigurationState {
  var dayOfWeekData: MemberHeaderItem? {
    get { return self[.dayOfWeek] as? MemberHeaderItem }
    set { self[.dayOfWeek] = newValue }
  }
}

class DayOfWeekHeaderListCell: UICollectionViewListCell {
  private var dayOfWeekData: MemberHeaderItem?
  private func defaultDayOfWeekConfiguration() -> UIListContentConfiguration {
    return .subtitleCell()
  }

  private lazy var dayOfWeeklistContentView = UIListContentView(configuration: defaultDayOfWeekConfiguration())

  func update(with newDayOfWeekData: MemberHeaderItem) {
    guard dayOfWeekData != newDayOfWeekData else {
      return
    }
    dayOfWeekData = newDayOfWeekData
    setNeedsUpdateConfiguration()
  }

  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.dayOfWeekData = self.dayOfWeekData
    return state
  }
}

extension DayOfWeekHeaderListCell {
  func setupViewsIfNeeded() {
    render()
  }

  override func updateConfiguration(using state: UICellConfigurationState) {
    setupViewsIfNeeded()

    var content = defaultDayOfWeekConfiguration().updated(for: state)
    guard let headerItem = state.dayOfWeekData else { return }
    // MARK: - NSMutableAttributedString
    // 월요일 .4
    let dayOfWeek = "\(headerItem.dayOfWeek)요일"
    let countOfTodo = " • \(String(headerItem.dayOfWeekTodos.count))"
    let headerText = dayOfWeek + countOfTodo

    // attributedString
    let mutableAttributedString = NSMutableAttributedString(string: headerText)
    mutableAttributedString.addAttributes([
      .font: Fonts.SpoqaHanSansNeo.medium.font(size: 14),
      .foregroundColor: Colors.black.color
    ], range: (headerText as NSString).range(of: dayOfWeek))
    mutableAttributedString.addAttributes([
      .font: Fonts.Montserrat.semiBold.font(size: 14),
      .foregroundColor: Colors.blueL1.color
    ], range: (headerText as NSString).range(of: countOfTodo))

    //content.attributedText
    content.attributedText = mutableAttributedString
    dayOfWeeklistContentView.configuration = content
  }
}

extension DayOfWeekHeaderListCell {
  private func render() {
    contentView.addSubview(dayOfWeeklistContentView)
    dayOfWeeklistContentView.translatesAutoresizingMaskIntoConstraints = false
    dayOfWeeklistContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
