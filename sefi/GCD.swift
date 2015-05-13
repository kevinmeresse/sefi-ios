//
//  GCD.swift
//  sefi
//
//  Created by Kevin Meresse on 4/20/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import Foundation

// This file contains utility functions
// that use the Grand Central Dispatch API.

/**
Invokes the closure after `delay` seconds has elapsed.
Source: http://stackoverflow.com/a/24318861/708350
*/
func delay(delay: Double, closure: () -> ())
{
    let
    delta = Int64(delay * Double(NSEC_PER_SEC)),
    when  = dispatch_time(DISPATCH_TIME_NOW, delta),
    queue = dispatch_get_main_queue()
    dispatch_after(when, queue, closure)
}