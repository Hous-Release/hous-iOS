//
//  MainHomeService.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import Foundation
import RxSwift
import Alamofire

protocol MainHomeServiceType {
  func getHomeData() -> Observable<MainHomeDTO?>
}

class MainHomeService: MainHomeServiceType {
  
  func getHomeData() -> Observable<MainHomeDTO?> {
    
    return Observable.create { observer in
      
      self.fetchHomeData { error, homeData in
        
        if let error = error {
          observer.onError(error)
        }
        
        if let homeData = homeData {
          observer.onNext(homeData)
        }
        
        observer.onCompleted()
      }
      
      return Disposables.create()
    }
  }
  
  private func fetchHomeData(completion: @escaping ((Error?, MainHomeDTO?) -> Void)) {
    let urlString = "43.200.122.252:8081/home"
    
    guard let url = URL(string: urlString) else { return completion(NSError(domain: "hous", code: 404), nil)}
    
    AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
      .responseDecodable(of: MainHomeDTO.self) { response in
        if let err = response.error {
          return completion(err, nil)
        }
        
        if let homeData = response.value {
          return completion(nil, homeData)
        }
      }
  }
}
