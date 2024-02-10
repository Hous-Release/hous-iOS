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
    func updateRule(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, ruleId: Int, images: [UIImage]) -> Observable<Int>
    func createRules(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, images: [UIImage]) -> Observable<Int>
    func deleteRule(ruleId: Int) -> Observable<Int>
    func updateRepresentRules(_ requestDTO: RuleDTO.Request.RepresentRulesRequestDTO) -> Observable<Void>
    func getRuleDetail(ruleId: Int) -> Observable<RuleDTO.Response.SingleRuleResponseDTO?>
}

public final class RuleAPI: APIRequestLoader<RuleService>, RuleAPIProtocol {
    public func updateRepresentRules(_ requestDTO: RuleDTO.Request.RepresentRulesRequestDTO) -> RxSwift.Observable<Void> {
        return Observable.create { [weak self] emitter in

            self?.fetchData(
                target: .updateRepresentRules(requestDTO),
                responseData: BaseResponseType<String>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }

                if result != nil {
                    emitter.onNext(())
                    emitter.onCompleted()
//                    if let status = result?.status {
//                        emitter.onNext(())
//                        emitter.onCompleted()
//                    }
                }
            }

            return Disposables.create()
        }
    }
    
    public func getRuleDetail(ruleId: Int) -> RxSwift.Observable<RuleDTO.Response.SingleRuleResponseDTO?> {
        return Observable.create { [weak self] emitter in

            self?.fetchData(
                target: .getRuleDetail(ruleId: ruleId),
                responseData: BaseResponseType<RuleDTO.Response.SingleRuleResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }

                if result != nil {
                    emitter.onNext(result?.data)
                    emitter.onCompleted()
                }
            }

            return Disposables.create()
        }
    }

    public func deleteRule(ruleId: Int) -> RxSwift.Observable<Int> {
        return Observable.create { [weak self] emitter in
            
            self?.fetchData(
                target: .deleteRule(ruleId: ruleId),
                responseData: BaseResponseType<RuleDTO.Response.updateRulesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                if result != nil {
                    emitter.onNext(ruleId)
                    emitter.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func createRules(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, images: [UIImage]) -> RxSwift.Observable<Int> {
        return Observable.create { [weak self] emitter in
            
            self?.fetchDataMultiPart(
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
    
    public func updateRule(_ ruleRequestDTO: RuleDTO.Request.createRuleRequestDTO, ruleId: Int, images: [UIImage]) -> Observable<Int> {
        
        return Observable.create { [weak self] emitter in
            
            self?.fetchDataMultiPart(
                target: .updateRule(ruleRequestDTO, ruleId: ruleId, images: images),
                responseData: BaseResponseType<RuleDTO.Response.updateRulesResponseDTO>.self
            ) { result, error in
                if let error = error {
                    emitter.onError(error)
                }
                
                guard let result else {
                    return
                }
                emitter.onNext(result.status)
                emitter.onCompleted()
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
