//
//  MainViewModel.swift
//  alif1
//
//  Created by Farangis Makhmadyorova on 13/12/22.
//

import Foundation
import SimpleTwoWayBinding

struct MainViewModel {
    let mainService = MainService.instance
    var mainData: Observable<[MainDetail]> = Observable([])
    
    func getMainData() {
        mainService.getData() { statusCode, response in
            if statusCode == 200 && response != nil {
                self.mainData.value = response?.data
            } else if statusCode == 401 {
                print("UNAUTHORIZED")
//                self.logoutDevice.value = true
            }
        }
    }
    
}

struct Main: Decodable {
    let data: [MainDetail]
    let total: String
}

struct MainDetail: Decodable {
    let url: String
    let startDate: String
    let endDate: String
    let name: String
    let icon: String
//    let venue: []
    let objType: String
    let loginRequired: Bool
}


