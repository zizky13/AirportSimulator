//
//  Gate.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

protocol Gate: AnyObject {
    var gateNumber: String { get }
    var assignedFlight: Flight? { get set }
    
    func assign(flight: Flight)
    func closeGate()
}
