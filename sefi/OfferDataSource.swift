//
//  OfferDataSource.swift
//  sefi
//
//  Created by Kevin Meresse on 4/20/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

/** Manages Place objects for the search controller's UITableView. */
class OfferDataSource: NSObject, UITableViewDataSource
{
    init(tableView: UITableView)
    {
        self.tableView = tableView
    }
    
    var offers: [Offer] = [] { didSet { tableView.reloadData() } }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return offers.count
    }
    
    func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OfferCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell
        let offer = offers[indexPath.row]
        cell.textLabel?.text = offer.jobTitle
        cell.detailTextLabel?.text = offer.location
        
        return cell
    }
    
    // MARK: - State
    
    private weak var tableView: UITableView!
}