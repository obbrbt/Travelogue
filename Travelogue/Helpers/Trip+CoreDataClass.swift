//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//
//

import UIKit
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    
    var entries: [Entry]?
    {
        return self.rawEntries?.array as? [Entry]
    }

    convenience init?(title: String)
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else
        {
            return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: context)
        
        self.title = title
    }
    
}
