//
//  File.swift
//  
//
//  Created by 김민재 on 2023/05/31.
//

import Foundation


public struct PhotoCellModel {
    public let ruleId: Int?
    public let title: String
    public let description: String?
    public let lastmodifedDate: String
    public let photos: [RulePhoto]?

    public init(
        ruleId: Int? = nil,
        title: String,
        description: String?,
        lastmodifedDate: String,
        photos: [RulePhoto]?) {
            self.ruleId = ruleId
            self.title = title
            self.description = description
            self.lastmodifedDate = lastmodifedDate
            self.photos = photos
        }
}
