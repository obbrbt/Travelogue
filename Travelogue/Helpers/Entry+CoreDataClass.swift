//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//
//

import UIKit
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    
    func convertToData(image: UIImage?) -> Data?
    {
        return image?.pngData() as Data?
    }
    
    var photo: UIImage?
    {
        get
        {
            if let imageData = rawImage
            {
                return UIImage(data: imageData)
            }
            return nil
        } set
        {
            rawImage = convertToData(image: newValue)
            if let imageNewValue = newValue
            {
                rawImage = convertToData(image: imageNewValue)
            }
        }
    }
    
    convenience init?(title: String?, body: String?, image: UIImage?)
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
              let title = title, title != "" else
        {
            return nil
        }
        
        self.init(entity: Entry.entity(), insertInto: managedContext)
        self.title = title
        self.body = body
        self.date = Date(timeIntervalSinceNow: 0)
        self.rawImage = convertToData(image: image)
    }
    
    func update(title: String?, body: String?, image: UIImage?)
    {
        self.title = title
        self.body = body
        self.date = Date(timeIntervalSinceNow: 0)
        self.rawImage = convertToData(image: image)
    }
}
