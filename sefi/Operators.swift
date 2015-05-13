//
//  Operators.swift
//  sefi
//
//  Created by Kevin Meresse on 4/20/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

/*
Marshal operator
Source: ijoshsmith.com/2014/07/05/custom-threading-operator-in-swift/
*/
infix operator ~> {}

// Serial dispatch queue used by the ~> operator.
private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

/**
Executes the lefthand closure on a background thread and,
upon completion, the righthand closure on the main thread.
*/
func ~> (
    backgroundClosure: () -> (),
    mainClosure:       () -> ())
{
    dispatch_async(queue) {
        backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), mainClosure)
    }
}

/**
Executes the lefthand closure on a background thread and,
upon completion, the righthand closure on the main thread.
Passes the background closure's output to the main closure.
*/
func ~> <R> (
    backgroundClosure: () -> R,
    mainClosure:       (result: R) -> ())
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue()) {
            mainClosure(result: result)
        }
    }
}

/**
Executes the lefthand closure on a background thread and,
upon completion, the righthand closure on the main thread.
Passes the background closure's tuple output to the main closure.
*/
func ~> <P, Q> (
    backgroundClosure: () -> (P, Q),
    mainClosure:       (first: P, second: Q) -> ())
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue()) {
            mainClosure(first: result.0, second: result.1)
        }
    }
}
