//
//  ProfileRequsetDTO.swift
//  
//
//  Created by 이의진 on 2022/11/10.
//

import Foundation

public extension ProfileDTO.Request {

    //MARK: ProfilePutEdit
    
    struct ProfileEditRequestDTO: Codable {
        public let birthday: String
        public let introduction: String?
        public let isPublic: Bool
        public let job: String?
        public let mbti: String?
        public let nickname: String
        
        
        public init(
            birthday: String,
            introduction: String?,
            isPublic: Bool,
            job: String?,
            mbti: String?,
            nickname: String
        ) {
            self.birthday = birthday
            self.introduction = introduction
            self.isPublic = isPublic
            self.job = job
            self.mbti = mbti
            self.nickname = nickname
        }
    }
    
    struct ProfileTestResultDTO: Encodable {
        public var color: String
        
        public init(color: String) {
            self.color = color
        }
    }
    
    struct ProfileTestSaveRequestDTO: Encodable {
        public let clean: Int
        public let introversion: Int
        public let light: Int
        public let noise: Int
        public let smell: Int
        
        public init(
            clean: Int,
            introversion: Int,
            light: Int,
            noise: Int,
            smell: Int
        ) {
            self.clean = clean
            self.light = light
            self.introversion = introversion
            self.noise = noise
            self.smell = smell
        }
    }
}
