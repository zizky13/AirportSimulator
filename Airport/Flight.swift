//
//  Flight.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

protocol Flight: AnyObject {
    var flightNumber: String { get }
    var destination: String { get }
    var departureTime: Date { get }
    var FlightStatus: FlightStatus { get set }
    var passengerCount: Int { get }
    var assignedPlane: Airplane? { get set }
    var assignedGate: Gate? { get set }
    
    func add(passenger: Passenger)
    func depart()
}

enum FlightStatus {
    case onTime
    case delayed
    case boarding
    case departed
    case atGate
    case scheduled
}
