//
//  File.swift
//  
//
//  Created by 김민재 on 2/11/24.
//

import UIKit

final class RuleGuideBottomSheetAction: BottomSheetAction {
    
    var view: RuleGuideBottomSheetView

    var completeAction: CompleteBottomSheetAction?

    init(view: RuleGuideBottomSheetView) { self.view = view }
}
