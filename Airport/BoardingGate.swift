//
//  BoardingGate.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

class BoardingGate: Gate {
    var gateNumber: String
    var assignedFlight: (any Flight)?
    
    init(gateNumber: String, assignedFlight: (any Flight)? = nil) {
        self.gateNumber = gateNumber
        self.assignedFlight = assignedFlight
    }
    
    deinit {
        print("Gate \(gateNumber) is deinitialized.")
    }
    
    func assign(flight: any Flight) {
        guard flight.FlightStatus == .boarding else {
            print("The flight is not in boarding status")
            return
        }
        
        guard self.assignedFlight == nil else {
            print("The gate is already used for another flight")
            return
        }
        
        self.assignedFlight = flight
    }
    
    // The Corrected Logic
    func closeGate() {
        self.assignedFlight = nil
        print("Gate \(gateNumber) is now free.")
    }
    
    
}
