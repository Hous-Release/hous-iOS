//
//  File 2.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation

protocol RuleAPIProtocol {
    func getRulesName(completion: @escaping (BaseResponseType<RuleDTO.Response.RuleResponseDTO>?, Error?) -> Void
  )
}

public final class RuleAPI: APIRequestLoader<RuleService>, RuleAPIProtocol {
    func getRulesName(completion: @escaping (BaseResponseType<RuleDTO.Response.RuleResponseDTO>?, Error?) -> Void) {
        fetchData(
            target: .getRuleData,
            responseData: BaseResponseType<RuleDTO.Response.RuleResponseDTO>.self,
        isWithInterceptor: true
        ) { res, err in
            completion(res, err)
        }
    }
}
