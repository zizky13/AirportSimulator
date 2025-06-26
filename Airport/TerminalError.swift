//
//  TerminalError.swift
//  Airport
//
//  Created by Zikar Nurizky on 25/06/25.
//

import Foundation

enum TerminalError: Error {
    case gateAlreadyExist(gateNumber: String)
    case flightAlreadyExist(flightNumber: String)
    case invalidPlaneAdd(status: AirplaneStatus)
    case unknownFlight(flightNumber: String)
    case unknownGate(gateNumber: String)
    case gateAlreadyAssigned
    case noPlaneAvailable(currentPlaneCount: Int)
    case planeCapacityExceeded
    case invalidPlaneAssignment
}
