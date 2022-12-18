//
//  PagingViewContents.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/24.
//

import UIKit

struct PagingContent: Equatable {
  let bigTitle: String
  let secondTitle: String
  let graphic: UIImage
}

extension PagingContent {
  static var sampleData: [PagingContent] = [
    PagingContent(bigTitle: "Welcome to\nYour Hous-",
                  secondTitle: "슬기로운 공동생활을 위한 서비스, Hous-\n\n우리의 Hous-를 위한 How is-\n반가워요, 호미들!",
                  graphic: Images.illOnboarding01.image),
    PagingContent(bigTitle: "Rules",
                  secondTitle: "Rules는 우리 집의 기둥이 될 중요한 규칙이에요!\n\n항상 놓치지 않고 지켜야 하는 것들을\nRules로 등록할 수 있어요 :)",
                  graphic: Images.illOnboarding02.image),
    PagingContent(bigTitle: "To-do",
                  secondTitle: "담당자와 요일을 설정할 수 있는 to-do!\n\n매일 매일 My to-do를 체크하고\n채워지는 Our to-do를 확인해 봐요~",
                  graphic: Images.illOnboarding03.image),
    PagingContent(bigTitle: "Homies",
                  secondTitle: "생활 성향 테스트를 참여하면 나를 대신해\n나를 잘 설명해줄 호미 성향 카드를 받을 수 있어요.\n\n이제 Hous-와 함께 우리 집 호미들의 성향 카드를\n확인하며 즐거운 공동생활을 시작해볼까요?",
                  graphic: Images.illOnboarding04.image)
  ]
}
