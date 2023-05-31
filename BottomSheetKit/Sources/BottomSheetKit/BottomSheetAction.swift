//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import UIKit

public typealias CompleteBottomSheetAction = ((DidBottomSheetActionType) -> Void)

protocol BottomSheetAction {
    associatedtype T: UIView
    func sendAction(_ action: DidBottomSheetActionType)
    func cancel()
    var completeAction: CompleteBottomSheetAction? { get }
    var view: T { get set }
    
}
