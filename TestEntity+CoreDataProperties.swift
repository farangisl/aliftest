//
//  TestEntity+CoreDataProperties.swift
//  
//
//  Created by Farangis Makhmadyorova on 15/12/22.
//
//

import Foundation
import CoreData


extension TestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var testValue: String?

}
