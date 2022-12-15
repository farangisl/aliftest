//
//  MainService.swift
//  alif1
//
//  Created by Farangis Makhmadyorova on 13/12/22.
//

import Foundation
import Alamofire

class MainService {
static let instance = MainService()
        
func getData(completion: @escaping (_ statusCode: Int?, _ response: Main?) -> Void) {

    AF.request("https://guidebook.com/service/v2/upcomingGuides/", method: .get, encoding: JSONEncoding.default).responseDecodable(of: Main.self) { response in
//            print(response.response?.statusCode)
            if response.response?.statusCode == 200 {
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        print(jsonData)
                        let data = try jsonDecoder.decode(Main.self, from: jsonData)
                        completion(200, data)
                    } catch let error {
                        print(error)
                    }
                }
            }
    }
    
}

}
