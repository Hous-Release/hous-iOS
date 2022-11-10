//
//  ProfileResponseDTO.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.


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
    
    
    // MARK: - GET Badge
    struct getBadgesResponseDTO: Decodable {
        public let badges: [Badge]
        public let representBadge: RepresentBadge?
    }
    
    // MARK: - Badge
    struct Badge: Decodable {
        public let badgeID: Int
        public let badgeDescription: String
        public let imageURL: String
        public let isAcquired: Bool
        public let isRead: Bool
        public let name: String

        enum CodingKeys: String, CodingKey {
            case badgeID = "badgeId"
            case badgeDescription = "description"
            case imageURL = "imageUrl"
            case isAcquired, isRead, name
        }
    }

    // MARK: - RepresentBadge
    struct RepresentBadge: Decodable {
        public let badgeID: Int
        public let imageURL: String
        public let name: String

        enum CodingKeys: String, CodingKey {
            case badgeID = "badgeId"
            case imageURL = "imageUrl"
            case name
        }
    }
    
    struct updateRepresentBadge: Decodable {
        
    }
}
