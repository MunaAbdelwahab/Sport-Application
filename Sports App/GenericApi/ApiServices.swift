//
//  ApiServices.swift
//  Movies List App
//
//  Created by Ahmed Badry on 3/17/21.
//

import Foundation
import Alamofire

class ApiServices {
    // singletone
    static let instance = ApiServices()
    
    func getDataFromApi <T: Decodable> (url: String ,completion: @escaping (T?,Error?)->Void) {
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            switch response.result{
            case .success(_):
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                completion(data , nil)
            } catch let error {
                print(error)
            }
            case . failure(let error):
            completion(nil , error)
            }
        }
    }
}
