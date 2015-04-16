import Foundation
import CoreData

@objc(Locations)
class Locations: NSManagedObject {
    
    @NSManaged var distance: NSNumber
    @NSManaged var location_address: NSString
    @NSManaged var location_date_created: NSDate
    @NSManaged var location_id: NSString
    @NSManaged var location_latitude: NSNumber
    @NSManaged var location_longitude: NSNumber
    @NSManaged var location_name: NSString
    @NSManaged var location_postcode: NSString
    @NSManaged var location_slug: NSString
    @NSManaged var location_town: NSString
    @NSManaged var post_id: NSString
    @NSManaged var events: NSSet
    
    
}

