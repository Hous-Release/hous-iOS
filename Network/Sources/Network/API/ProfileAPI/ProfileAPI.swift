//
//  ProfileAPI.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//

import Foundation

protocol ProfileAPIProtocol {
    
    func getProfileInfo(completion: @escaping
     (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void
    )
}

public final class ProfileAPI: APIRequestLoader<ProfileService>, ProfileAPIProtocol {
    public func getProfileInfo(completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getProfile, responseData: BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
}
