//
//  AuthService.swift
//  Splashing
//
//  Created by 안재영 on 2020/09/01.
//  Copyright © 2020 안재영. All rights reserved.
//

import AuthenticationServices
import KeychainAccess
import RxSwift

protocol AuthServiceType {
  func authorize() -> Observable<Void>
  func logout()
  
  var accessToken: AccessToken? { get }
}

class AuthService: NSObject, AuthServiceType {
  let callbackSubject = PublishSubject<String>()
  let keychain        = Keychain(service: "com.splashing.ios")

  var authenticateSession: ASWebAuthenticationSession?
  var accessToken:         AccessToken?
  
  override init() {
    super.init()
    self.accessToken = self.loadAccessToken()
    log.debug("Access token exists: \(self.accessToken != nil)")
  }
  
  func authorize() -> Observable<Void> {
    let authorizeQueryItems: [URLQueryItem] = [
      URLQueryItem(name: "client_id",     value: API.accessKey),
      URLQueryItem(name: "redirect_uri",  value: "splashing://oauth/callback"),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope",         value: "public+read_user+read_photos")
    ]
    
    guard var component  = URLComponents(string: API.authorizeURL) else { return .never() }
    component.queryItems = authorizeQueryItems
    
    self.authenticateSession = ASWebAuthenticationSession(url: component.url!,
                                                          callbackURLScheme: "splashing://oauth/callback",
                                                          completionHandler: { url, error in
        guard let code = url?.value(for: "code") else { return }
        self.callback(code: code)
    })
    self.authenticateSession?.presentationContextProvider = self
    self.authenticateSession?.start()

    return self.callbackSubject
      .flatMap(self.accessToken)
      .do(onNext: { [weak self] accessToken in
        try self?.savaAccessToken(accessToken)
        self?.accessToken = accessToken
      })
      .map { _ in }
  }
  
  func callback(code: String) {
    self.callbackSubject.onNext(code)
  }
  
  func logout() {
    self.accessToken = nil
    self.deleteAccessToken()
  }
  
  private func accessToken(code: String) -> Single<AccessToken> {
    let accessTokenQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "client_id",     value: API.accessKey),
        URLQueryItem(name: "client_secret", value: API.secretKey),
        URLQueryItem(name: "redirect_uri",  value: "splashing://oauth/callback"),
        URLQueryItem(name: "code",          value: code),
        URLQueryItem(name: "grant_type",    value: "authorization_code")
    ]
    
    guard var component = URLComponents(string: API.accessTokenURL) else { return .never() }
    component.queryItems = accessTokenQueryItems

    var request = URLRequest(url: component.url!)
    request.httpMethod = "POST"
    
    return Single.create { single in
      let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
          do {
            let accessToken = try JSONDecoder().decode(AccessToken.self, from: data)
            single(.success(accessToken))
          } catch let error {
            single(.error(error))
          }
        }
      }
      dataTask.resume()
      
      return Disposables.create {
        dataTask.cancel()
      }
    }
  }

  private func loadAccessToken() -> AccessToken? {
    guard let number = self.keychain["access_token"],
          let type   = self.keychain["token_type"],
          let scope  = self.keychain["scope"] else { return nil }
    
    return AccessToken(number: number, type: type, scope: scope)
  }
  
  private func savaAccessToken(_ accessToken: AccessToken) throws {
    try self.keychain.set(accessToken.number, key: "access_token")
    try self.keychain.set(accessToken.type,   key: "token_type")
    try self.keychain.set(accessToken.scope,  key: "scope")
  }
  
  private func deleteAccessToken() {
    try? self.keychain.remove("access_token")
    try? self.keychain.remove("token_type")
    try? self.keychain.remove("scope")
  }
}

extension AuthService: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return ASPresentationAnchor()
  }
}
