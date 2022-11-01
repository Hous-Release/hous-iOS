//
//  ProfileResponseDTO.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//


import Foundation

public extension ProfileDTO.Response {
    
    //MARK: ProfileGet
    struct ProfileGetResponseDTO : Codable {
        public let birthday: String?
        public let birthdayPublic: Bool
        public let age: String
        public let introduction, job, mbti, nickname, personalityColor, representBadge, representBadgeImage: String?
        public let testScore: TestScore?
    }
    
    struct TestScore: Codable {
        public let clean, introversion, light, noise, smell: Double
    }
    
}
