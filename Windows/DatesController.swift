//
//  DatesController.swift
//  Windows
//
//  Created by B Gay on 8/3/19.
//  Copyright © 2019 B Gay. All rights reserved.
//

import Foundation

// Data controller that manages array of dates and informs observers when changes occur
final class DatesController: NSObject {
    
    // Singleton instance
    static let shared = DatesController()
    
    // Array of dates
    var dates = [Date]() {
        didSet {
            // On modification call each of our observers
            onUpdates.forEach { onUpdate in
                onUpdate()
            }
        }
    }
    
    // Private array that holds each of our observers
    private var onUpdates = [() -> Void]()
    
    // Function to add an onUpdate observer
    func addOnUpdate(_ onUpdate: @escaping () -> Void) {
        onUpdates.append(onUpdate)
    }
}
