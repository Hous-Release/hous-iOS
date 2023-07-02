//
//  Constant.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/13.
//

import Foundation

enum StringLiterals {
  enum NavigationBar {
    enum Title {
      static let ruleMainTitle = "우리 집 Rules"
      static let addEditTitle = "Rules 추가"
    }
  }

  enum SearchBar {
    enum Rule {
      static let placeholder = "검색하기"
    }
  }

  enum OurRule {
    enum MainView {
      static let new = "new !"
    }
    enum AddEditView {
      static let titleText = "제목 *"
      static let description = "설명"
      static let photo = "사진"
    }
  }

  enum ButtonTitle {
    enum Rule {
      static let edit = "편집"
      static let guide = "가이드 다시보기"
      static let add = "추가"
      static let addPhoto = "추가하기"
    }
  }

}

enum SizeLiterals {
  enum NavigationBar {
    static let height = 64
  }

  enum FilterButton {
    static let height = 32
  }
}
