//
//  FilterView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/03.
//

import UIKit

class FilterView: UIView {

  var resultCnt: Int = 0 {
    didSet {

      let fullText = "검색 결과 \(resultCnt)개"
      let attributedString = NSMutableAttributedString(
        string: fullText)
      let range = (fullText as NSString).range(of: "\(resultCnt)")
      attributedString.addAttributes([
        NSAttributedString.Key.font: Fonts.SpoqaHanSansNeo.medium.font(size: 13),
        NSAttributedString.Key.foregroundColor: Colors.blue.color
      ], range: range)

      filterResultLabel.attributedText = attributedString
    }
  }

  // let defaultFilterButton: 

  var filterButton = UIButton().then {
    $0.configuration = .plain()
  }

  lazy var filterResultLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    label.textColor = Colors.g4.color
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FilterView {

  private func configUI() {

    addSubViews([filterResultLabel])

    filterResultLabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(8)
      make.trailing.equalToSuperview().inset(28)
    }
  }
}
