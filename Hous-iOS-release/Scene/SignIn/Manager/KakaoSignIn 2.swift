//
//  KakaoSignIn.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

protocol KakaoOAuthable {
  func configure(appKey: String)
}

final public class KakaoOAuthManager: NSObject {
  private var _onSuccess: Success?
  private var _onFailure: Failure?
}

extension KakaoOAuthManager: KakaoOAuthable {

  public func configure(appKey: String) {
    KakaoSDK.initSDK(appKey: appKey)
  }
}

extension KakaoOAuthManager: OAuthable {

  public func login() {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
        if let error = error {
          debugPrint(error)
          self?.onFailure?(error)
        }

        guard let oauthToken = oauthToken else {
          self?.onFailure?(NSError.init(domain: "Kakao Login Error", code: -1))
          debugPrint("Kakao Login Error")
          return
        }
        self?.onSuccess?(oauthToken.accessToken, nil)
      }

    } else {
      UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
        if let error = error {
          self?.onFailure?(error)
        }

        guard let oauthToken = oauthToken else {
          self?.onFailure?(NSError.init(domain: "Kakao Login Error", code: -1))
          debugPrint("Kakao Login Error")
          return
        }
        self?.onSuccess?(oauthToken.accessToken, nil)
      }
    }

  }

  public var onSuccess: ((String, String?) -> ())? {
    get {
      return _onSuccess
    }
    set(value){
      _onSuccess = value
    }
  }

  public var onFailure: ((Error) -> ())? {
    get {
      return _onFailure
    }
    set(value) {
      _onFailure = value
    }
  }

}
