//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var body: String?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var trips: Trip?

}

extension Entry : Identifiable {

}
