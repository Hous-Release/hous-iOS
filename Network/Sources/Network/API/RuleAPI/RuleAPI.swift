//
//  File 2.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import UIKit
import RxSwift

protocol RuleAPIProtocol {
    func getRulesName() -> Observable<[RuleDTO.Response.Rule]>
    func updateRules(_ ruleRequestDTO: RuleDTO.Request.updateRulesRequestDTO) -> Observable<Void>
    func createRules(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, images: [UIImage]) -> Observable<Int>
    func deleteRules(_ ruleRequestDTO: RuleDTO.Request.deleteRulesRequestDTO) -> Observable<Void>
}

public final class RuleAPI: APIRequestLoader<RuleService>, RuleAPIProtocol {
    public func deleteRules(_ ruleRequestDTO: RuleDTO.Request.deleteRulesRequestDTO) -> RxSwift.Observable<Void> {
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .deleteRule(ruleRequestDTO),
                responseData: BaseResponseType<RuleDTO.Response.updateRulesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if result != nil {
                    emitter.onNext(())
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func createRules(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, images: [UIImage]) -> RxSwift.Observable<Int> {
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .createRule(ruleRequestDTO, images: images),
                responseData: BaseResponseType<RuleDTO.Response.updateRulesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if result != nil {
                    if let status = result?.status {
                        emitter.onNext(status)
                        emitter.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func updateRules(_ ruleRequestDTO: RuleDTO.Request.updateRulesRequestDTO) -> Observable<Void> {
        
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .updateRules(ruleRequestDTO),
                responseData: BaseResponseType<RuleDTO.Response.updateRulesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if result != nil {
                    emitter.onNext(())
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    public func getRulesName() -> Observable<[RuleDTO.Response.Rule]> {
        
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .getRuleData,
                responseData: BaseResponseType<RuleDTO.Response.RuleResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if let result = result {
                    emitter.onNext(result.data?.rules ?? [])
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
