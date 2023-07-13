import UIKit

import AssetKit

/**
 Hous 프로젝트에서 기본적으로 사용하는 Label 클래스
 */
public final class HousLabel: UILabel {

  /// Font는 반드시 ``HousFont``를 사용할 것
  ///
  public init(text: String?, font: HousFont, textColor: UIColor) {
    super.init(frame: .zero)
    setStyle(text: text, font: font, textColor: textColor)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle(text: String?,
                        font housFontEnum: HousFont,
                        textColor: UIColor) {
    self.text = text
    self.font = housFontEnum.font
    self.textColor = textColor
  }
}
