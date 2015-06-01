//
//  ListAppliedOffersViewController.swift
//  sefi
//
//  Created by Kevin Meresse on 5/8/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class ListAppliedOffersViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    var dataSource: OfferDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = OfferDataSource(tableView: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        retrieveAppliedOffers()
        
        // Allow the primary and detail views to show simultaneously.
        splitViewController?.preferredDisplayMode = .AllVisible
        
        // Show an "empty view" on the right-hand side, only on an iPad.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            let emptyVC = storyboard!.instantiateViewControllerWithIdentifier("EmptyOfferViewController") as! UIViewController
            if splitViewController != nil {
                splitViewController!.showDetailViewController(emptyVC, sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let offerDetailsNC = storyboard!.instantiateViewControllerWithIdentifier("OfferDetailsNavigationController") as! UINavigationController
        let offerDetailsVC = offerDetailsNC.topViewController as! DetailViewController
        offerDetailsVC.detailItem = dataSource.offers[indexPath.row]
        if splitViewController != nil {
            splitViewController!.showDetailViewController(offerDetailsNC, sender: self)
        } else {
            navigationController!.pushViewController(offerDetailsVC, animated: true)
        }
    }
    
    
    // MARK: - API calls
    
    private func retrieveAppliedOffers() {
        SOAPService
            .POST(RequestFactory.retrieveAppliedOffers())
            .success({xml in {XMLParser.createOffers(xml, isNewOffers: false)} ~> {self.updateOffers($0)}})
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func updateOffers(offers: [Offer]) {
        self.dataSource.offers = offers
        self.loadingView.hidden = true
        if offers.count > 0 {
            self.tableView.hidden = false
        } else {
            self.emptyView.hidden = false
        }
    }
    
    private func onFailure(statusCode: Int, error: NSError?)
    {
        println("HTTP status code \(statusCode)")
        
        let
        title = "Erreur",
        msg   = error?.localizedDescription ?? "Une erreur est survenue.",
        alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

}
