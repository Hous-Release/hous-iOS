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



class BadgeViewModel: ViewModelType {
  struct Input {
    let viewWillAppear: Observable<Void>
    let backButtonDidTapped: Observable<Void>
    //    let badgeDidTapped: Observable<Void>
  }
  
  struct Output {
    let isRepresentBadgeExist: Driver<Bool>
    let sections: Driver<[SectionOfProfile]>
    //    let popViewController: Driver<Void>
    //    let badgeClickStatus: Drive
  }
  
  private let disposeBag = DisposeBag()
  
  
  
  func transform(input: Input) -> Output {
    let viewWillAppear = input.viewWillAppear
      .flatMap { _ -> Observable<ProfileDTO.Response.getBadgesResponseDTO> in
        return NetworkService.shared.profileRepository.getBadges()
      }
    
    
    
    //    let representBadgeImage = viewWillAppear
    //      .map({ badgeDTO -> String in
    //        title = badgeDTO.representBadge?.name ?? "dd"
    //        return badgeDTO.representBadge?.imageURL ?? ""
    //      })
    //      .withUnretained(self)
    //      .flatMap { vc, urlString in
    //        return vc.loadImage(url: urlString)
    //      }
    //      .map { image in
    //        let item = BadgeCollectionViewItem.representingBadge(viewModel: RepresentingBadgeViewModel(
    //          image: image,
    //          title: title))
    //        return item
    //      }
    //
    //    let badgeImages = viewWillAppear
    //      .map { badgeDTO -> [String] in
    //        var badgeImagesURL: [String] = []
    //        badgeDTO.badges.forEach { badge in
    //          badgeImagesURL.append(badge.imageURL)
    //        }
    //        return badgeImagesURL
    //      }
    //      .withUnretained(self)
    //      .flatMap { vc, urlStrings in
    //        urlStrings.forEach { url in
    //          vc.loadImage(url: url)
    //        }
    //      }
    
    
    var isExistRepresentBadge = true
    
    let sections = viewWillAppear
      .withUnretained(self)
      .map { vm, badgeDTO -> [SectionOfProfile] in
        
        var representItems: [BadgeCollectionViewItem] = []
        var badgesItems: [BadgeCollectionViewItem] = []
        
        if let representBadge = badgeDTO.representBadge {
          
          vm.loadImage(url: representBadge.imageURL)
            .subscribe(onNext: { image in
              let item = BadgeCollectionViewItem.representingBadge(viewModel: RepresentingBadgeViewModel(
                image: image,
                title: representBadge.name))
              
              representItems.append(item)
            })
            .disposed(by: vm.disposeBag)
          
        } else {
          let item = BadgeCollectionViewItem.representingBadge(viewModel: RepresentingBadgeViewModel(image: UIImage(), title: ""))
          representItems.append(item)
        }
        
        let representBadgeId = badgeDTO.representBadge?.badgeID
        
        badgeDTO.badges.forEach { badge in
          var flag = false
          if badge.badgeID == representBadgeId {
            flag = true
          }
          vm.loadImage(url: badge.imageURL)
            .subscribe(onNext: { img in
              let badgeItem = BadgeCollectionViewItem.badges(viewModel: RoomBadgeViewModel(id: badge.badgeID, image: img, title: badge.name, description: badge.badgeDescription, isAcquired: badge.isAcquired, isRepresenting: flag))
              badgesItems.append(badgeItem)
            })
            .disposed(by: vm.disposeBag)
        }
        
        
        let representModel = SectionOfProfile(model: .representingBadge, items: representItems)
        let badgeModel = SectionOfProfile(model: .badges, items: badgesItems)
        
        return [representModel, badgeModel]
      }
    
    
    //      .map { [SectionOfProfile(model: .representingBadge, items: $0)] }
    
    
    //    let badges = viewWillAppear.map { [weak self] badgeDTO -> [BadgeCollectionViewItem] in
    //      guard let self = self else { return [] }
    //      var items: [BadgeCollectionViewItem] = []
    //
    //      badgeDTO.badges.forEach { badge in
    //        guard let url = URL(string: badge.imageURL) else { return }
    //        self.loadImage(url: url)
    //          .subscribe(onNext: { img in
    //            guard let image = img else { return }
    //            let item = BadgeCollectionViewItem.badges(viewModel: RoomBadgeViewModel(
    //              image: image,
    //              title: badge.name,
    //              description: badge.badgeDescription,
    //              isAcquired: badge.isAcquired)
    //            )
    //
    //            items.append(item)
    //          })
    //          .disposed(by: self.disposeBag)
    //      }
    //      return items
    //    }
    //      .map { [SectionOfProfile(model: .badges, items: $0)] }
    
    
    
    
    let isRepresentBadgeExist = Observable.just(isExistRepresentBadge)
      .asDriver(onErrorJustReturn: false)
    
    return Output(
      isRepresentBadgeExist: isRepresentBadgeExist,
      sections: sections.asDriver(onErrorJustReturn: [])
      //      popViewController: input.backButtonDidTapped.asDriver(onErrorJustReturn: ())
    )
  }
  
  
}

extension BadgeViewModel {
  
  func loadImage(url: String) -> Observable<UIImage> {
    guard let url = URL(string: url),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data)
    else { return .empty() }
    return .just(image)
  }
  
  //  func loadImage(url: String) -> Observable<UIImage?> {
  //    return Observable<UIImage?>.create { emitter in
  //
  //      guard let url = URL(string: url) else {
  //        emitter.onNext(nil)
  //        emitter.onCompleted()
  //        return
  //      }
  //
  //      let task = URLSession.shared.dataTask(with: url) { data, _, err in
  //
  //        guard let data = data else {
  //          emitter.onError(err)
  //          return
  //        }
  //
  //        let image = UIImage(data: data)
  //        emitter.onNext(image)
  //        emitter.onCompleted()
  //      }
  //
  //      task.resume()
  //
  //      return Disposables.create {
  //        task.cancel()
  //      }
  //    }
  //  }
  
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
  let image: UIImage
  let title: String
  let description: String
  let isAcquired: Bool
  let isRepresenting: Bool
  
  init(id: Int, image: UIImage, title: String, description: String, isAcquired: Bool, isRepresenting: Bool) {
    self.id = id
    self.image = image
    self.title = title
    self.description = description
    self.isAcquired = isAcquired
    self.isRepresenting = isRepresenting
  }
}


struct RepresentingBadgeViewModel {
  let image: UIImage?
  var title: String
  
  init(image: UIImage?, title: String) {
    self.image = image
    self.title = title
  }
  
}


