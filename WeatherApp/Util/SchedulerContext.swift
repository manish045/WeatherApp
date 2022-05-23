//
//  SchedulerContext.swift
//  Video Streamer
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Combine

public protocol SchedulerContext {
    
    var state: DispatchQueue { get }
    
    var async: DispatchQueue { get }
    
    var concurrent: DispatchQueue { get }
    
    var ui: DispatchQueue { get }
    
}

public struct SchedulerContextProvider: SchedulerContext {
    
    public let state: DispatchQueue
    
    public let async: DispatchQueue
    
    public let concurrent: DispatchQueue
    
    public let ui: DispatchQueue
    
    public static func provide() -> SchedulerContext {
        return SchedulerContextProvider(state: DispatchQueue(label: "com.ios.app.State",
                                                             qos: .userInteractive),
                                        async: DispatchQueue(label: "com.ios.app.Serial",
                                                             qos: .userInitiated),
                                        concurrent: DispatchQueue.global(qos: .background),
                                        ui: DispatchQueue.main)
    }
    
}
