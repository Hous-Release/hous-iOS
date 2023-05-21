//
//  File.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import Foundation

public enum Button {

    public enum Onboarding: String {
        case next = "다음으로"
        case createRoom = "방 만들기"
        case leaveProfile = "탈퇴하기"
    }

    public enum Login {
        static let kakao = "카카오톡으로 계속하기"
        static let apple = "Apple로 계속하기"
        static let save = "저장하기"
        static let retry = "다시 검사해보기"
    }
}
