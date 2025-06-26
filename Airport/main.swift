//
//  main.swift
//  Airport
//
//  Created by Zikar Nurizky on 19/06/25.
//

import Foundation


func testAirport() {
    // MARK: - Airport Simulation
    print("\n\n==========================================")
    print("      AIRPORT SIMULATION START      ")
    print("==========================================")

    // 1. Setup the Terminal and its assets
    let terminal = Terminal()
    print("Terminal A is now open.")

    do {
        try terminal.addGate(BoardingGate(gateNumber: "A1"))
        try terminal.addGate(BoardingGate(gateNumber: "A2"))
        print("Gates A1 and A2 have been added.")
    } catch let error as TerminalError {
        switch error {
        case .gateAlreadyExist(let gateNumber):
            print("Gate number \(gateNumber) already exist!")
        default:
            print("An error out of context has occured!")
        }
    } catch {
        print("An unknown error has occured!")
    }

    do {
        try terminal.addPlane(Airplane(model: "Boeing 737", passengerCapacity: 180, AirplaneStatus: .atGate))
        try terminal.addPlane(Airplane(model: "Airbus A380", passengerCapacity: 550, AirplaneStatus: .atGate))
        print("A Boeing 737 and an Airbus A380 are available at the terminal.")
    } catch let error as TerminalError {
        switch error {
        case .invalidPlaneAdd(let status):
            print("Cannot add plane with status \(status).")
        default:
            print("An unknown error has occured!")
        }
    } catch {
        print("An error beyond our reach has occured!")
    }

    // 2. Create some passengers and flights
    let passengersForLondon = [Passenger(name: "John Appleseed", ticketedFlightNumber: "BA2492"), Passenger(name: "Jane Smith", ticketedFlightNumber: "BA2492")]
    let londonFlight = CommercialFlight(boardedPassengers: passengersForLondon, flightNumber: "BA2492", destination: "London", departureTime: Date().addingTimeInterval(3600 * 3), FlightStatus: .scheduled) /*CommercialFlight(passengers: passengersForLondon, flightNumber: "BA2492", destination: "London", departureTime: Date().addingTimeInterval(3600 * 3), status: .scheduled, assignedPlane: nil)*/ // Departs in 3 hours

    let passengersForTokyo = (1...200).map { Passenger(name: "Passenger \($0)", ticketedFlightNumber: "JL044") }
    let tokyoFlight =  CommercialFlight(boardedPassengers: passengersForTokyo, flightNumber: "JL044", destination: "Tokyo", departureTime: Date().addingTimeInterval(3600 * 5), FlightStatus: .scheduled) // Departs in 5 hours

    // 3. Schedule the flights
    print("\n--- Scheduling Flights ---")
    do {
        try terminal.schedule(flight: londonFlight)
        try terminal.schedule(flight: tokyoFlight)
    } catch let error as TerminalError {
        switch error {
        case .flightAlreadyExist(let flightNumber):
            print("Flight with number \(flightNumber) is already assigned")
        default:
            print("An unexpected error occurred: \(error)")
        }
    } catch {
        print("There is an unknown error occurred.")
    }


    // 4. Run the simulation loop over 8 "hours"
    print("\n--- Starting Simulation Loop ---")
    for hour in 0..<8 {
        let currentTime = Date().addingTimeInterval(TimeInterval(hour * 3600))
        print("\n--- Hour \(hour) (Time: \(currentTime.formatted(date: .omitted, time: .shortened))) ---")

        // Simulate specific operational events at certain hours
        if hour == 1 {
            print("\n[Operations]: Assigning planes to flights...")
            do {
                try terminal.assignPlaneToFlight(flightNumber: "BA2492") // Should succeed with the 737
                try terminal.assignPlaneToFlight(flightNumber: "JL044") // Should succeed with the A380

            } catch let error as TerminalError {
                switch error {
                case .unknownFlight(let flightNumber):
                    print("Flight with number: \(flightNumber) is unknown.")
                case .planeCapacityExceeded:
                    print("Cannot assign flight as plane capacity is exceeded.")
                default:
                    print("An unknown error has occured: \(error)")
                }
            } catch {
                print("An error out of our reach has occured!")
            }
        }
        
        if hour == 2 {
            print("\n[Operations]: Opening boarding...")
            do {
                try terminal.openBoardingFor(flightNumber: "BA2492")
            } catch let error as TerminalError {
                switch error {
                case .unknownFlight(let flightNumber):
                    print( "Flight with number \(flightNumber) is unknown.")
                case .gateAlreadyAssigned:
                    print("Cannot open boarding for a flight that already has a gate assigned.")
                default:
                    print("An unknown error has occured: \(error)")
                }
            } catch {
                print("An error out of reach has occured!")
            }
        }
        
        if hour == 3 {
             print("\n[Passenger Action]: Passengers are boarding flight BA2492...")
            // Try to board the two passengers
            let firstPassenger = passengersForLondon[0]
            londonFlight.add(passenger: firstPassenger)
            
            let wrongPassenger = Passenger(name: "Gary Busey", ticketedFlightNumber: "UA901")
            londonFlight.add(passenger: wrongPassenger) // Should fail
        }

        // This is the "tick" of our simulation clock.
        // It will check if any flights are due for departure at the current hour.
        terminal.updateFlights(currentTime: currentTime)
        
        // Give a quick status update at the end of the hour
    //    terminal.printStatus()
    }
    print(terminal.flightsReadyForBoarding())
    print(terminal.getDepartingPlaneModels())

    print("\n==========================================")
    print("            SIMULATION END            ")
    print("==========================================")
}

func runMemoryCycleTest() {
    print("\n--- Running Memory Cycle Test ---")
    
    var flight: Flight? = CommercialFlight(boardedPassengers: [], flightNumber: "MEM-TEST-001", destination: "MEMORY LANE", departureTime: Date(), FlightStatus: .boarding)
    var gate: Gate? = BoardingGate(gateNumber: "B23")
    
    print("Objects created: Flight MEM-TEST-001 and Gate B23\n")
    
    flight?.assignedGate = gate
    gate?.assign(flight: flight!)
    
    print("Object have been assigned to each other.")
    print("----------------------------------------\n")
    
    print("Breaking strong references from the test function...")
    flight = nil
    gate = nil
    
    print("---- Memory Cycle Test Finished ----")
}

runMemoryCycleTest()
