//
//  MainDetailEntity+CoreDataProperties.swift
//  
//
//  Created by Farangis Makhmadyorova on 15/12/22.
//
//

import Foundation
import CoreData


extension MainDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainDetailEntity> {
        return NSFetchRequest<MainDetailEntity>(entityName: "MainDetailEntity")
    }

    @NSManaged public var url: String?
    @NSManaged public var startDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var name: String?
    @NSManaged public var icon: String?
    @NSManaged public var objType: String?
    @NSManaged public var loginRequired: Bool

}
