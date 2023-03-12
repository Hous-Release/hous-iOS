//
//  ProfileTestViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/15.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileTestInfoViewModel: ViewModelType {

  private let disposeBag: DisposeBag = DisposeBag()

  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileTestInfoActionControl>
  }

  struct Output {
    let actionControl: Observable<ProfileTestInfoActionControl>
  }

  func transform(input: Input) -> Output {

    // Action

    let actionControl = input.actionDetected.asObservable()

    return Output(
      actionControl: actionControl
    )
  }
}

final class ProfileTestViewModel: ViewModelType {

  private let disposeBag: DisposeBag = DisposeBag()
  private var profileTestItemModels = [ProfileTestItemModel]()
  private var profileTestItemModelSubject = PublishSubject<[ProfileTestItemModel]>()
  private let profileRepository = ProfileRepositoryImp()
  var selectedData = [Int](repeating: 0, count: 15)
  let selectedDataSubject = PublishSubject<[Int]>()
  var questionTypes: [String] = []

  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileTestActionControl>
  }

  struct Output {
    let profileTestData: Observable<[ProfileTestItemModel]>
    let actionControl: Observable<ProfileTestActionControl>
    let selectedDataObservable: Observable<[Int]>
  }

  init() {
    ProfileRepositoryImp.event
      .subscribe(onNext: { [weak self] event in
        guard let self = self else { return }
        switch event {
        case let .getProfileTest(profileTestItemModels):
          self.profileTestItemModels = profileTestItemModels
          self.profileTestItemModelSubject.onNext(profileTestItemModels)
          for model in profileTestItemModels {
            self.questionTypes.append(model.questionType)
          }
        case .sendError:
          print("😭 Network Error..😭")
          print(event)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
  }

  func transform(input: Input) -> Output {

    // Data
    self.profileRepository.getProfileTest()
    self.profileTestItemModelSubject.onNext(self.profileTestItemModels)

    let profileTestItemModelObservable = profileTestItemModelSubject.asObservable()

    // Action

    let actionControl = input.actionDetected.asObservable()

    actionControl
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case let .didTabAnswer(answer, questionNum):
          self.selectedData[questionNum - 1] = answer
          self.profileTestItemModels[questionNum - 1].testAnswers.forEach {
            $0.isSelected = false
          }
          self.profileTestItemModels[questionNum - 1].testAnswers[answer-1].isSelected = true
          self.profileTestItemModelSubject.onNext(self.profileTestItemModels)
        default:
          break
        }
      })
      .disposed(by: disposeBag)

    // SelectedLogic
    self.selectedDataSubject.onNext(self.selectedData)

    let selectedDataObservable = selectedDataSubject.asObservable()

    return Output(
      profileTestData: profileTestItemModelObservable,
      actionControl: actionControl,
      selectedDataObservable: selectedDataObservable
    )
  }
}
