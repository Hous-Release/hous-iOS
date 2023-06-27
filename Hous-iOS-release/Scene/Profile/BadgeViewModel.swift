//
//  BadgeViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Network
import Kingfisher

class BadgeViewModel: ViewModelType {
  struct Input {
    let viewWillAppear: Observable<Void>
    let backButtonDidTapped: Observable<Void>
    let selectedMainBadge: Observable<Int>
  }

  struct Output {
    let sections: Driver<[SectionOfProfile]>
    let badgesWithState: Driver<[RoomBadgeViewModel]>
    let updatedRepresentBadge: Driver<Int>
    let popViewController: Driver<Void>
  }

  private let disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let viewWillAppear = input.viewWillAppear
      .flatMap { _ -> Observable<ProfileDTO.Response.getBadgesResponseDTO> in
        return NetworkService.shared.profileRepository.getBadges()
      }

    let sections = viewWillAppear
      .withUnretained(self)
      .map { _, badgeDTO -> [SectionOfProfile] in

        var representItems: [BadgeCollectionViewItem] = []
        var badgesItems: [BadgeCollectionViewItem] = []

        if let representBadge = badgeDTO.representBadge {

          let item = BadgeCollectionViewItem.representingBadge(viewModel: RepresentingBadgeViewModel(
            imageURL: representBadge.imageURL,
            title: representBadge.name))

          representItems.append(item)

        } else {
          let item = BadgeCollectionViewItem.representingBadge(
            viewModel: RepresentingBadgeViewModel(imageURL: "", title: ""))
          representItems.append(item)
        }

        let representBadgeId = badgeDTO.representBadge?.badgeID

        badgeDTO.badges.forEach { badge in
          var flag = false
          var tapState: BadgeViewTapState = .none
          if badge.badgeID == representBadgeId {
            flag = true
            tapState = .representing
          }

          let badgeItem = BadgeCollectionViewItem.badges(viewModel: RoomBadgeViewModel(
            id: badge.badgeID,
            imageURL: badge.imageURL,
            title: badge.name,
            description: badge.badgeDescription,
            isAcquired: badge.isAcquired,
            isRepresenting: flag,
            tapState: tapState
          )
          )

          badgesItems.append(badgeItem)
        }

        let representModel = SectionOfProfile(model: .representingBadge, items: representItems)
        let badgeModel = SectionOfProfile(model: .badges, items: badgesItems)

        return [representModel, badgeModel]
      }

    let badgesWithState = viewWillAppear.map { dto -> [RoomBadgeViewModel] in
      let representBadgeId = dto.representBadge?.badgeID
      var badges: [RoomBadgeViewModel] = []

      dto.badges.forEach { badge in

        var tapState: BadgeViewTapState = .none
        var flag = false

        if badge.badgeID == representBadgeId {
          flag = true
          tapState = .representing
        }

        let model = RoomBadgeViewModel(id: badge.badgeID,
                                       imageURL: badge.imageURL,
                                       title: badge.name,
                                       description: badge.badgeDescription,
                                       isAcquired: badge.isAcquired,
                                       isRepresenting: flag,
                                       tapState: tapState)
        badges.append(model)
      }
      return badges
    }
      .asDriver(onErrorJustReturn: [])

    let updatedRepresentBadge = input.selectedMainBadge
      .flatMap({ badgeId -> Observable<Int> in
        return NetworkService.shared.profileRepository.updateRepresentBadge(badgeId)
      })
      .asDriver(onErrorJustReturn: -1)

    let popViewController = input.backButtonDidTapped
      .asDriver(onErrorJustReturn: ())

    return Output(
      sections: sections.asDriver(onErrorJustReturn: []),
      badgesWithState: badgesWithState,
      updatedRepresentBadge: updatedRepresentBadge,
      popViewController: popViewController
    )
  }

}

typealias SectionOfProfile = SectionModel<BadgeCollectionViewSection, BadgeCollectionViewItem>

enum BadgeCollectionViewSection {
  case representingBadge
  case badges
}

enum BadgeCollectionViewItem {
  case representingBadge(viewModel: RepresentingBadgeViewModel)
  case badges(viewModel: RoomBadgeViewModel)
}

struct RoomBadgeViewModel {
  let id: Int
  let imageURL: String
  let title: String
  let description: String
  let isAcquired: Bool
  let isRepresenting: Bool
  var tapState: BadgeViewTapState
}

struct RepresentingBadgeViewModel {
  let imageURL: String
  var title: String
}

enum BadgeViewTapState {
  case none
  case selected
  case representing
}
