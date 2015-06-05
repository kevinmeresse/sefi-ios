//
//  DetailViewController.swift
//  sefi
//
//  Created by Kevin Meresse on 4/16/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var applyButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contractTypeLabel: UILabel!
    @IBOutlet weak var carLicenceLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var boatLicenceLabel: UILabel!
    @IBOutlet weak var studiesLevelLabel: UILabel!
    @IBOutlet weak var experienceTimeLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var softwareExpertiseLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var applyDateLabel: UILabel!
    @IBOutlet weak var offerIdLabel: UILabel!
    @IBOutlet weak var offerDateLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    
    var itemIndex: Int?
    var detailItem: Offer? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func apply(sender: AnyObject) {
        // Show loading view and disable button
        loadingView.hidden = false
        applyButton.enabled = false
        
        // Call webservice
        if let offer: Offer = self.detailItem {
            SOAPService
                .POST(RequestFactory.applyOffer(offer))
                .success({xml in {XMLParser.checkIfApplied(xml)} ~> {self.offerIsApplied($0, message: $1)}})
                .failure(onFailure, queue: NSOperationQueue.mainQueue())
        }
    }
    
    private func offerIsApplied(success: Bool, message: String?) {
        // Hide loading view and re-enable button
        loadingView.hidden = true
        applyButton.enabled = true
        
        if success {
            println("SUCCESS: Offer is favorited!")
            showInformationPopup("Félicitations", message: "Votre demande a bien été prise en compte !", whenDone: {
                // Delete current offer from list
                if self.splitViewController != nil && self.itemIndex != nil {
                    if let offersNC = self.splitViewController?.viewControllers.first as? UINavigationController {
                        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
                            if let offersVC = offersNC.visibleViewController as? ListOffersViewController {
                                offersVC.dataSource.offers.removeAtIndex(self.itemIndex!)
                            }
                        } else if offersNC.viewControllers.count > 1 {
                            if let offersVC = offersNC.viewControllers[offersNC.viewControllers.count - 2]  as? ListOffersViewController {
                                offersVC.dataSource.offers.removeAtIndex(self.itemIndex!)
                            }
                        }
                        // Go back to the list
                        offersNC.popViewControllerAnimated(true)
                    }
                }
                
                // Show an "empty view" on the right-hand side, only on an iPad.
                if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
                {
                    let emptyVC = self.storyboard!.instantiateViewControllerWithIdentifier("EmptyOfferViewController") as! UIViewController
                    self.splitViewController!.showDetailViewController(emptyVC, sender: self)
                }
            })
        } else {
            println("FAILURE: Offer is NOT favorited...")
            showInformationPopup("Ooops", message: "Une erreur s'est produite. Votre demande n'a pas été prise en compte...", whenDone: nil)
        }
    }
    
    private func showInformationPopup(title: String, message: String, whenDone: (() -> ())?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { _ in
                //self.dismissViewControllerAnimated(true, completion: nil)
                if whenDone != nil {
                    whenDone!()
                }
        }))
        
        presentViewController(alert, animated: true, completion: nil)
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
    
    func configureView() {
        // Update the user interface for the detail item.
        if let offer: Offer = self.detailItem {
            if let label = self.titleLabel {
                label.text = offer.jobTitle
            }
            if let label = self.idLabel {
                label.text = offer.id
            }
            if let label = self.locationLabel {
                label.text = offer.location
            }
            if let label = self.contractTypeLabel {
                label.text = offer.contractType
            }
            if let label = self.carLicenceLabel {
                label.text = offer.carLicence
            }
            if let label = self.degreeLabel {
                label.text = offer.degree
            }
            if let label = self.experienceLabel {
                label.text = offer.experience
            }
            if let label = self.numberLabel {
                label.text = offer.number
            }
            if let label = self.availabilityLabel {
                label.text = offer.availability
            }
            if let label = self.boatLicenceLabel {
                label.text = offer.boatLicence
            }
            if let label = self.studiesLevelLabel {
                label.text = offer.studiesLevel
            }
            if let label = self.experienceTimeLabel {
                label.text = offer.experienceTime
            }
            if let label = self.jobDescriptionLabel {
                label.text = offer.jobDescription
            }
            if let label = self.conditionsLabel {
                label.text = offer.conditions
            }
            if let label = self.softwareExpertiseLabel {
                label.text = offer.softwareExpertise
            }
            if let label = self.languageLabel {
                label.text = offer.languages
            }
            if let view = self.companyView {
                if offer.applied {
                    // Hide Apply button
                    navigationItem.rightBarButtonItems = []
                } else {
                    // Hide Company details
                    view.removeFromSuperview()
                }
            }
            if let label = self.nameLabel {
                label.text = "\(offer.lastName!) \(offer.firstName!)"
            }
            if let label = self.applyDateLabel {
                label.text = offer.applyDate
            }
            if let label = self.offerIdLabel {
                label.text = offer.id
            }
            if let label = self.offerDateLabel {
                label.text = offer.offerDate
            }
            if let label = self.companyLabel {
                label.text = offer.companyName
            }
            if let label = self.contactLabel {
                label.text = offer.companyContact
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSizeMake(600, 1000)

        // Do any additional setup after loading the view.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
