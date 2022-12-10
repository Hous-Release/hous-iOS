//
//  File.swift
//  
//
//  Created by 김지현 on 2022/12/10.
//

import Foundation

protocol UserAPIProtocol {
  func deleteUser(
    _ dto: UserDTO.Request.DeleteUserRequestDTO,
    completion: @escaping
      (BaseResponseType<String>?, Error?) -> Void
  )
}

public final class UserAPI: APIRequestLoader<UserService>, UserAPIProtocol {

    public func deleteUser(
        _ dto: UserDTO.Request.DeleteUserRequestDTO,
        completion: @escaping (BaseResponseType<String>?, Error?) -> Void
    ) {
        fetchData(
            target: .deleteUser(dto),
            responseData: BaseResponseType<String>.self) { res, err in
                completion(res,err)
            }
    }
}
