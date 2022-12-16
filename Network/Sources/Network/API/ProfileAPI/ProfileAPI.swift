//
//  ProfileAPI.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.

import Foundation
import RxSwift

protocol ProfileAPIProtocol {
    
    func getAlarmInfo(dto: ProfileDTO.Request.GetAlarmRequestDTO, completion: @escaping
                             (BaseResponseType<ProfileDTO.Response.GetAlarmResponseDTO>?, Error?) -> Void
    )
    
    func patchAlarmSettingInfo(_ alarmSettingRequestDTO: ProfileDTO.Request.SaveAlarmSettingRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.SaveAlarmSettingResponseDTO>?, Error?) -> Void)
    
    func getAlarmSettingInfo(completion: @escaping
                             (BaseResponseType<ProfileDTO.Response.GetAlarmSettingResponseDTO>?, Error?) -> Void
    )
    
    func putProfileTest(_ profileTestRequestDTO: ProfileDTO.Request.ProfileTestSaveRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileTestSaveResponseDTO>?, Error?) -> Void)
    
    func getProfileTest(completion: @escaping
     (BaseResponseType<[ProfileDTO.Response.ProfileTestResponseDTO]>?, Error?) -> Void
    )
    
    func getProfileTestResultInfo(dto: ProfileDTO.Request.ProfileTestResultDTO, completion: @escaping
     (BaseResponseType<ProfileDTO.Response.ProfileTestResultResponseDTO>?, Error?) -> Void
    )
    
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
    public func getAlarmInfo(dto: ProfileDTO.Request.GetAlarmRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.GetAlarmResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getAlarmInfo(dto), responseData: BaseResponseType<ProfileDTO.Response.GetAlarmResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
    
    public func getAlarmSettingInfo(completion: @escaping (BaseResponseType<ProfileDTO.Response.GetAlarmSettingResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getAlarmSettingInfo, responseData: BaseResponseType<ProfileDTO.Response.GetAlarmSettingResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
    
    public func getProfileTest(completion: @escaping (BaseResponseType<[ProfileDTO.Response.ProfileTestResponseDTO]>?, Error?) -> Void) {
        fetchData(target: .getProfileTest, responseData: BaseResponseType<[ProfileDTO.Response.ProfileTestResponseDTO]>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
    public func getProfileTestResultInfo(dto: ProfileDTO.Request.ProfileTestResultDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileTestResultResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getProfileTestResult(dto), responseData: BaseResponseType<ProfileDTO.Response.ProfileTestResultResponseDTO>.self, isWithInterceptor: true) {res, err in
            completion(res, err)
        }
    }
    
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
    
    public func patchAlarmSettingInfo(_ alarmSettingRequestDTO: ProfileDTO.Request.SaveAlarmSettingRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.SaveAlarmSettingResponseDTO>?, Error?) -> Void) {
        fetchData(target: .patchAlarmSetting(alarmSettingRequestDTO), responseData: BaseResponseType<ProfileDTO.Response.SaveAlarmSettingResponseDTO>.self, isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
    
    public func putProfileEditInfo(_ profilePutRequestDTO: ProfileDTO.Request.ProfileEditRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileEditResponseDTO>?, Error?) -> Void) {
        fetchData(target: .putProfileEdit(profilePutRequestDTO), responseData: BaseResponseType<ProfileDTO.Response.ProfileEditResponseDTO>.self, isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
    
    public func putProfileTest(_ profileTestRequestDTO: ProfileDTO.Request.ProfileTestSaveRequestDTO, completion: @escaping (BaseResponseType<ProfileDTO.Response.ProfileTestSaveResponseDTO>?, Error?) -> Void) {
        fetchData(target: .putProfileTest(profileTestRequestDTO), responseData: BaseResponseType<ProfileDTO.Response.ProfileTestSaveResponseDTO>.self, isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
    
    
    
}
