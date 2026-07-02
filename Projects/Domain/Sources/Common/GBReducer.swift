//
//  GBReducer.swift
//  Domain
//
//  Created by Jae hyung Kim on 5/23/25.
//

import Foundation

public protocol GBReducer: Sendable {
    associatedtype ViewCycle
    associatedtype ViewEvent
}
