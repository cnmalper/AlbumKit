//
//  Photo+CoreDataProperties.swift
//  AlbumKit
//
//  Created by Alper Canımoğlu on 10.01.2024.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var photoID: UUID?
    @NSManaged public var album: Album?

}

extension Photo : Identifiable {

}
