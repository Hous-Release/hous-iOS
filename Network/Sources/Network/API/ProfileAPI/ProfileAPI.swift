//
//  ProfileAPI.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.

import Foundation
import RxSwift

protocol ProfileAPIProtocol {
    
    func getHomieProfileInfo(id: String, completion: @escaping
     (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void
    )
    
    func getProfileInfo(completion: @escaping
     (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void
    )
    
    func getBadges() -> Observable<ProfileDTO.Response.getBadgesResponseDTO>
    func updateRepresentBadge(_ id: Int) -> Observable<Int>
    
    func putProfileEditInfo(
        _ profileEditRequestDTO: ProfileDTO.Request.ProfileEditRequestDTO,
        completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileEditResponseDTO>?, Error?) -> Void
    )
}

public final class ProfileAPI: APIRequestLoader<ProfileService>, ProfileAPIProtocol {
    public func getHomieProfileInfo(id: String, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getHomieProfile(id), responseData: BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
    
    public func getProfileInfo(completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getProfile, responseData: BaseResponseType<ProfileDTO.Response.ProfileGetResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
    
    
    public func getBadges() -> Observable<ProfileDTO.Response.getBadgesResponseDTO> {
        
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .getBadges,
                responseData: BaseResponseType<ProfileDTO.Response.getBadgesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if let result = result {
                    if let data = result.data {
                        emitter.onNext(data)
                        emitter.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func updateRepresentBadge(_ id: Int) -> Observable<Int> {
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .updateRepresentBadge(id),
                responseData: BaseResponseType<ProfileDTO.Response.updateRepresentBadge>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if result != nil {
                    emitter.onNext(id)
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func putProfileEditInfo(_ profilePutRequestDTO: ProfileDTO.Request.ProfileEditRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileEditResponseDTO>?, Error?) -> Void) {
        fetchData(target: .putProfileEdit(profilePutRequestDTO), responseData: BaseResponseType<ProfileDTO.Response.ProfileEditResponseDTO>.self, isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
    
    
    
}
