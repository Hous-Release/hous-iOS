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
                  graphic: UIImage(systemName: "star")!),
    PagingContent(bigTitle: "Rules",
                  secondTitle: "우리집의 기둥이 될 Rules예요!\n\n항상 놓치지 않고 지켜야 하는 것들을\nRules로 등록할 수 있어요 :)",
                  graphic: UIImage(systemName: "star")!),
    PagingContent(bigTitle: "To-do",
                  secondTitle: "요일과 담당자를 설정할 수 있는 to-do!\n\n매일 매일 My to-do를 체크하고\n채워지는 Our to-do를 확인해봐요~",
                  graphic: UIImage(systemName: "star")!),
    PagingContent(bigTitle: "Homies",
                  secondTitle: "생활 성향 테스트를 참여하면 우리 집 모든\n호미들에게 내 성향 카드를 보여줄 수 있어요.\n\n호미카드는 나 대신 나를 잘 설명해줄 거예요!",
                  graphic: UIImage(systemName: "star")!)
  ]
}
