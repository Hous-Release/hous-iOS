//
//  File.swift
//  
//
//  Created by 김민재 on 2023/05/30.
//

import Foundation

final class RuleBottomSheetAction: BottomSheetAction {

    let view: RuleBottomSheetView
    var completeAction: CompleteBottomSheetAction?

    init(view: RuleBottomSheetView) { self.view = view }

    func sendAction(_ action: DidBottomSheetActionType) {
        print(action)
        completeAction?(action)
    }

    func cancel() {
        completeAction?(.cancel)
    }

}
