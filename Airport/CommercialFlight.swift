//
//  CommercialFlight.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

class CommercialFlight: Flight {
    var boardedPassengers: [Passenger]
    var assignedPlane: Airplane?
    var flightNumber: String
    var destination: String
    var departureTime: Date
    var FlightStatus: FlightStatus
    var passengerCount: Int {
        return boardedPassengers.count
    }
    weak var assignedGate: Gate?
    
    init(boardedPassengers: [Passenger], assignedPlane: Airplane? = nil, flightNumber: String, destination: String, departureTime: Date, FlightStatus: FlightStatus) {
        self.boardedPassengers = boardedPassengers
        self.assignedPlane = assignedPlane
        self.flightNumber = flightNumber
        self.destination = destination
        self.departureTime = departureTime
        self.FlightStatus = FlightStatus
    }
    
    deinit {
        print("Flight \(flightNumber) has been deallocated")
    }

    func depart() {
        FlightStatus = .departed
        assignedPlane?.AirplaneStatus = .inAir
    }
    
    func add(passenger: Passenger) {
        guard !boardedPassengers.contains(where: { $0.name == passenger.name }) else {
            print("Passenger already on flight")
            return
        }
        
        guard passenger.ticketedFlightNumber == flightNumber else {
            print ("Passenger not on this flight")
            return
        }
        
        guard FlightStatus == .boarding else {
            print("The plane is no more taking any passengers")
            return
        }
        
        boardedPassengers.append(passenger)
    }
}
