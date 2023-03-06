//
//  AppleSignIn.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import AuthenticationServices

protocol AppleOAuthable {
  func configure(in viewController: UIViewController)
}

final public class AppleOAuthManager: NSObject {
  private weak var viewController: UIViewController?
  private var _onSuccess: Success?
  private var _onFailure: Failure?
}

extension AppleOAuthManager: AppleOAuthable {
  public func configure(in viewController: UIViewController) {
    self.viewController = viewController
  }
}

extension AppleOAuthManager: OAuthable {

  public var onSuccess: ((String, String?) -> Void)? {
    get {
      return _onSuccess
    }
    set(value) {
      _onSuccess = value
    }
  }

  public var onFailure: ((Error) -> Void)? {
    get {
      return _onFailure
    }
    set(value) {
      _onFailure = value
    }
  }

  public func login() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

extension AppleOAuthManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return viewController!.view.window!
  }
}

extension AppleOAuthManager: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return
    }
    guard
      let identityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8),
      let authorizeCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8)
    else { return }

    onSuccess?(identityToken, authorizeCode)
  }
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    onFailure?(error)
  }
}
