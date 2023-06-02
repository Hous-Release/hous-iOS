import UIKit

import AssetKit

public final class HousLabel: UILabel {

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
