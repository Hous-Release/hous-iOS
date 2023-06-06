//
//  File.swift
//  
//
//  Created by 김민재 on 2023/05/30.
//

import Foundation

final class RuleBottomSheetAction: BottomSheetAction {

    var view: RuleBottomSheetView

    var completeAction: CompleteBottomSheetAction?

    init(view: RuleBottomSheetView) { self.view = view }
}
