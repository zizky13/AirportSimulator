//
//  Airplane.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

class Airplane {
    var model: String
    var passengerCapacity: Int
    var AirplaneStatus: AirplaneStatus
    
    init(model: String, passengerCapacity: Int, AirplaneStatus: AirplaneStatus) {
        self.model = model
        self.passengerCapacity = passengerCapacity
        self.AirplaneStatus = AirplaneStatus
    }
}

enum AirplaneStatus {
    case atGate
    case inAir
    case maintenance
}
