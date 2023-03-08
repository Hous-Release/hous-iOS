//
//  TodoByMemListCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/27.
//

import UIKit
import Network

protocol DidTapMemTodoDelegate: AnyObject {
  func didTapTodo(todoId: Int)
}

private extension UIConfigurationStateCustomKey {
  static let todoByMem = UIConfigurationStateCustomKey("todoByMem")
}

extension UIConfigurationState {
  var todoByMemData: TodoInfoWithIdModel? {
    get { return self[.todoByMem] as? TodoInfoWithIdModel }
    set { self[.todoByMem] = newValue }
  }
}

class TodoByMemListCell: UICollectionViewListCell {
  private var todoByMemData: TodoInfoWithIdModel?
  var delegate: DidTapMemTodoDelegate?

  private func defaultTodoByMemConfiguration() -> UIListContentConfiguration {
    return .subtitleCell()
  }

  private lazy var todoByMemlistContentView = UIListContentView(configuration: defaultTodoByMemConfiguration())

  func update(with newTodoByMemData: TodoInfoWithIdModel) {
    guard todoByMemData != newTodoByMemData else {
      return
    }
    todoByMemData = newTodoByMemData
    setNeedsUpdateConfiguration()
  }

  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.todoByMemData = self.todoByMemData
    return state
  }
}

extension TodoByMemListCell {
  func setupViewsIfNeeded() {
    render()
  }

  override func updateConfiguration(using state: UICellConfigurationState) {
    setupViewsIfNeeded()

    var content = defaultTodoByMemConfiguration().updated(for: state)
    guard let todoItem = state.todoByMemData else { return }
    content.image = Images.dotTodobymem.image
    content.imageToTextPadding = 14
    content.attributedText = NSAttributedString(
      string: todoItem.todoName,
      attributes: [
        .font: Fonts.SpoqaHanSansNeo.medium.font(size: 14),
        .foregroundColor: Colors.black.color
      ])
    todoByMemlistContentView.configuration = content

    var background = UIBackgroundConfiguration.listPlainCell().updated(for: state)
    background.backgroundColor = .clear
    self.backgroundConfiguration = background

    if state.isSelected {
      let todo = todoByMemData ?? TodoInfoWithIdModel(todoId: 0, todoName: "")
      delegate?.didTapTodo(todoId: todo.todoId)
    }
  }
}

extension TodoByMemListCell {
  private func render() {
    contentView.addSubview(todoByMemlistContentView)
    todoByMemlistContentView.translatesAutoresizingMaskIntoConstraints = false
    todoByMemlistContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(36)
    }
  }
}
