//
//  UIControl+Combine.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/07/04.
//

import UIKit
import Combine

final class UIControlSubscription<
  SubscriberType: Subscriber,
  Control: UIControl
>: Subscription where SubscriberType.Input == Control {

  private var subscriber: SubscriberType?
  private let control: Control

  init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
    self.subscriber = subscriber
    self.control = control
    control.addTarget(self, action: #selector(eventHandler), for: event)
  }

  /// Subscription protocol 채택 시 구현해야하는 request, cancel 메서드
  func request(_ demand: Subscribers.Demand) {
    /// event 발생만 캐치하고 싶기 때문에 아무 동작 x
  }

  func cancel() {
    subscriber = nil
  }

  @objc private func eventHandler() {
    _ = subscriber?.receive(control)
  }
}

struct UIControlPublsher<Control: UIControl>: Publisher {

  /// Publisher 프로토콜의 associated type 필수 지정
  typealias Output = Control
  typealias Failure = Never

  let control: Control
  let controlEvents: UIControl.Event

  init(control: Control, events: UIControl.Event) {
    self.control = control
    self.controlEvents = events
  }

  func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Control == S.Input {
    let subscription = UIControlSubscription(
      subscriber: subscriber,
      control: control,
      event: controlEvents
    )
    subscriber.receive(subscription: subscription)
  }
}

protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
  func publisher(for events: UIControl.Event) -> UIControlPublsher<UIControl> {
    return UIControlPublsher(control: self, events: events)
  }
}
