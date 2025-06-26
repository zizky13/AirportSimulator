//
//  Terminal.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation

class Terminal {
    private var scheduledFlights: [Flight] = []
    private var availablePlanes: [Airplane] = []
    private var gates: [Gate] = []
    
    init() {}
    
    func addGate(_ gate: Gate) throws {
        /*A function to add gate into available gates in terminal
        might throw an error if the added gate number is exist at terminal gates
         */
        
        guard gates.contains(where: { $0.gateNumber == gate.gateNumber }) == false else {
            throw TerminalError.gateAlreadyExist(gateNumber: gate.gateNumber)
        }
        
        self.gates.append(gate)
    }
    
    func schedule(flight: Flight) throws {
        guard scheduledFlights.contains(where: { $0.flightNumber == flight.flightNumber }) == false else {
            throw TerminalError.flightAlreadyExist(flightNumber: flight.flightNumber)
        }
        
        scheduledFlights.append(flight)
    }
    
    func addPlane(_ plane: Airplane) throws {
        guard plane.AirplaneStatus != .maintenance && plane.AirplaneStatus != .inAir else {
            throw TerminalError.invalidPlaneAdd(status: plane.AirplaneStatus)
        }
        
        self.availablePlanes.append(plane)
        print("Plane added!")
    }
    
    func openBoardingFor(flightNumber: String) throws {
        guard let flight = scheduledFlights.first(where: { $0.flightNumber == flightNumber }) else {
            throw TerminalError.unknownFlight(flightNumber: flightNumber)
        }
        
        guard let gate = gates.first(where: { $0.assignedFlight == nil }) else {
            throw TerminalError.gateAlreadyAssigned
        }
        
        if let index = gates.firstIndex(where: { $0.gateNumber == gate.gateNumber }){
            gates.remove(at: index)
        }
        
        gate.assign(flight: flight)
        flight.FlightStatus = .boarding
        print("Boarding for flight '\(flightNumber)' started!")
    }
    
    func assignPlaneToFlight(flightNumber: String) throws {
        guard let flight = scheduledFlights.first(where: { $0.flightNumber == flightNumber }) else {
            throw TerminalError.unknownFlight(flightNumber: flightNumber)
        }
        
        guard availablePlanes.count > 0 else {
            throw TerminalError.noPlaneAvailable(currentPlaneCount: availablePlanes.count)
        }
        
        guard let plane = availablePlanes.first(where: {
            $0.passengerCapacity >= flight.passengerCount
        }) else {
            throw TerminalError.planeCapacityExceeded
        }
        
        flight.assignedPlane = plane
        
        if let index = availablePlanes.firstIndex(where: { $0 === plane}){
            availablePlanes.remove(at: index)
        }
        
        if let flightIndex = scheduledFlights.firstIndex(where: {$0.flightNumber == flightNumber }){
            scheduledFlights[flightIndex] = flight
        }
        
        print("Sucessfully assigned plane \(plane.model) to flight \(flightNumber)")
        
    }
    
    func updateFlights(currentTime: Date){
        for flight in scheduledFlights {
            if currentTime >= flight.departureTime {
                flight.depart()
            }
        }
    }
    
    
    //======= FUNCTIONAL PROGRAMMING PART =======
    //Core functional programming concept is that we produce new transformed data, not transform the existing
    func allFlightNumber() -> [String] {
        return scheduledFlights.map(\.flightNumber) //return new array of flight number string
    }
    
    func flightsReadyForBoarding() -> [Flight] {
        return scheduledFlights.filter {
            $0.FlightStatus == .scheduled && $0.assignedPlane != nil
        }
    }
    
    func totalPassengerCapacityAtGate() -> Int {
        return availablePlanes
            .filter { $0.AirplaneStatus == .atGate }
            .map(\.passengerCapacity)
            .reduce(0, +)
    }
    
    func getDepartingPlaneModels() -> [String] {
        return scheduledFlights
            .filter { $0.FlightStatus == .departed }
            .compactMap { $0.assignedPlane } //to make sure the return consist no nil
            .map(\.model)
    }
    
}
