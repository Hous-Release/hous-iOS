//
//  File 2.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation
import RxSwift

protocol RuleAPIProtocol {
    func getRulesName() -> Observable<[RuleDTO.Response.Rule]>
}

public final class RuleAPI: APIRequestLoader<RuleService>, RuleAPIProtocol {
    public func getRulesName() -> Observable<[RuleDTO.Response.Rule]> {
        print("getRulesName 호출됨 ! ")
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(target: .getRuleData,
                      responseData: BaseResponseType<RuleDTO.Response.RuleResponseDTO>.self) { result, error in
                
                if let error = error {
                    emitter.onError(error)
                }
                if let result = result {
                    print("=============")
                    print(result)
                    emitter.onNext(result.data?.rules ?? [])
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
