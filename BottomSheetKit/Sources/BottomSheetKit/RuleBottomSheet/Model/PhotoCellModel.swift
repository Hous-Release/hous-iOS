//
//  File.swift
//  
//
//  Created by 김민재 on 2023/05/31.
//

import Foundation


public struct PhotoCellModel {
    let title: String
    let description: String
    let lastmodifedDate: String
    let photos: [RulePhoto]?

    public init(
        title: String,
        description: String,
        lastmodifedDate: String,
        photos: [RulePhoto]?) {
        self.title = title
        self.description = description
        self.lastmodifedDate = lastmodifedDate
        self.photos = photos
    }
}
