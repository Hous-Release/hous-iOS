//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/23.
//

import Foundation

protocol MainHomeAPIProtocol {
    func getHomeData(completion: @escaping (BaseResponseType<MainHomeDTO.Response.MainHomeResponseDTO>?, Error?) -> Void
  )
}

public final class MainHomeAPI: APIRequestLoader<MainHomeService>, MainHomeAPIProtocol {
    public func getHomeData(completion: @escaping (BaseResponseType<MainHomeDTO.Response.MainHomeResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getHomeData,
                  responseData: BaseResponseType<MainHomeDTO.Response.MainHomeResponseDTO>.self,
                  isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
}
