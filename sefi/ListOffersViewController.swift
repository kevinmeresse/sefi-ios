//
//  ListOffersViewController.swift
//  sefi
//
//  Created by Kevin Meresse on 5/7/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class ListOffersViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    var dataSource: OfferDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("ListOffersViewController:viewDidLoad")

        dataSource = OfferDataSource(tableView: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        println("ListOffersViewController:viewDidLoad: Retrieving new offers...")
        retrieveNewOffers()
        println("ListOffersViewController:viewDidLoad: Finished retrieving new offers...")
        
        // Allow the primary and detail views to show simultaneously.
        splitViewController?.preferredDisplayMode = .AllVisible
        
        // Show an "empty view" on the right-hand side, only on an iPad.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            let emptyVC = storyboard!.instantiateViewControllerWithIdentifier("EmptyOfferViewController") as! UIViewController
            splitViewController!.showDetailViewController(emptyVC, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        displayOfferFromIndexPath(indexPath)
    }
    
    
    // MARK: - API calls
    
    private func retrieveNewOffers() {
        SOAPService
            .POST(RequestFactory.retrieveNewOffers())
            .success({xml in {XMLParser.createOffers(xml, isNewOffers: true)} ~> {self.updateOffers($0)}})
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func updateOffers(offers: [Offer]) {
        println("ListOffersViewController:updateOffers: Updating list with new offers...")
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
    
    
    // MARK: - Actions
    
    @IBAction func unwindToMainList(sender: UIStoryboardSegue) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            displayOfferFromIndexPath(indexPath)
        } else if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            // Show an "empty view" on the right-hand side, only on an iPad.
            let emptyVC = storyboard!.instantiateViewControllerWithIdentifier("EmptyOfferViewController") as! UIViewController
            splitViewController!.showDetailViewController(emptyVC, sender: self)
        }
    }
    
    @IBAction func goToAppliedOffers(sender: AnyObject) {
        //let appliedOffersNC = storyboard!.instantiateViewControllerWithIdentifier("AppliedOffersNavigationController") as! UINavigationController
        //splitViewController!.showViewController(appliedOffersNC, sender: self)
        let appliedOffersVC = storyboard!.instantiateViewControllerWithIdentifier("AppliedOffersViewController") as! UIViewController
        if splitViewController != nil {
            let navController = splitViewController!.viewControllers[0] as! UINavigationController
            navController.pushViewController(appliedOffersVC, animated: true)
        } else if navigationController != nil {
            navigationController!.pushViewController(appliedOffersVC, animated: true)
        }
    }
    
    private func displayOfferFromIndexPath(indexPath: NSIndexPath) {
        let offerDetailsNC = storyboard!.instantiateViewControllerWithIdentifier("OfferDetailsNavigationController") as! UINavigationController
        let offerDetailsVC = offerDetailsNC.topViewController as! DetailViewController
        offerDetailsVC.detailItem = dataSource.offers[indexPath.row]
        offerDetailsVC.itemIndex = indexPath.row
        if splitViewController != nil {
            splitViewController!.showDetailViewController(offerDetailsNC, sender: self)
        } else if navigationController != nil {
            navigationController!.pushViewController(offerDetailsVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let offer = dataSource.offers[indexPath.row] as Offer
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = offer
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }*/
    }

}
