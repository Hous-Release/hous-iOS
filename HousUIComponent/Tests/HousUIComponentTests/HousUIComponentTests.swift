import XCTest
@testable import HousUIComponent

final class HousUIComponentTests: XCTestCase {


  func testIsValidate_초기설정() {
    let rounded = RoundedTextFieldWithCount(maxCount: 20)
    XCTAssertEqual(rounded.isValidate, false)
  }

  func testIsValidate_1글자() {
    let rounded = RoundedTextFieldWithCount(maxCount: 20)
    rounded.text = "1"
    XCTAssertEqual(rounded.isValidate, true)
  }

  func testIsValidate_20글자() {
    let rounded = RoundedTextFieldWithCount(maxCount: 20)
    rounded.text = "12345678901234567890"
    XCTAssertEqual(rounded.isValidate, true)
  }

  func testIsValidate_21글자() {
    let rounded = RoundedTextFieldWithCount(maxCount: 20)
    rounded.text = "123456789012345678901"
    XCTAssertEqual(rounded.isValidate, false)
  }

}
