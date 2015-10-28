//
//  Globals.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 25/11/2014.
//  Copyright (c) 2014 Neil Oliver. All rights reserved.
//

import UIKit
import CoreLocation


var latValue: CLLocationDegrees = 0
var lonValue: CLLocationDegrees = 0
var locationObj: CLLocation!

var latMax: Double = 0
var latMin: Double = 0
var lngMax: Double = 0
var lngMin: Double = 0

// variables to hold core data querys for venues and events
var sortedVenueResults: NSArray!
var LocalEventResults: NSArray!

var venueSelect: Int = 0
var eventSelect: Int = 0
let dateTime = NSDate()

var formattedDateTime :String!

//var seletedCloseEvent: Events?
var selectedEvent: BAALinkedVenueEvents?
var closeEvents = []
var ArchiveEvents = [BAALinkedEventComments]()
var closeVenueEvents = [BAALinkedVenueEvents]()
var closeVenues = [BAAVenue]()
var venuesWithLinks = [BAAVenue]()
var eventComments = [BAALinkedEventComments]()
var gigFound : Bool = false

var OnlineSearch : Bool = false



