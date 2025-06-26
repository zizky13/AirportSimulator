//
//  Passenger.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

class Passenger {
    var name: String
    var ticketedFlightNumber: String
    
    init(name: String, ticketedFlightNumber: String) {
        self.name = name
        self.ticketedFlightNumber = ticketedFlightNumber
    }
}
