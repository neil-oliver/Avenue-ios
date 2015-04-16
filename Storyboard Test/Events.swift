import Foundation
import CoreData

@objc(Events)
class Events: NSManagedObject {
    
    @NSManaged var end_date_comparison_result: NSNumber
    @NSManaged var event_all_day: NSString
    @NSManaged var event_date_created: NSDate
    @NSManaged var event_date_modified: NSString
    @NSManaged var event_end: NSDate
    @NSManaged var event_end_date: NSString
    @NSManaged var event_end_time: NSString
    @NSManaged var event_name: NSString
    @NSManaged var event_owner: NSString
    @NSManaged var event_start: NSDate
    @NSManaged var event_start_date: NSString
    @NSManaged var event_start_time: NSString
    @NSManaged var event_status: NSString
    @NSManaged var location_id: NSString
    @NSManaged var post_id: NSString
    @NSManaged var start_date_comparison_result: NSNumber
    @NSManaged var locations: Locations
    

    
}
