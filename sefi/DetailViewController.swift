//
//  DetailViewController.swift
//  sefi
//
//  Created by Kevin Meresse on 4/16/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hireLabel: UILabel!
    @IBOutlet weak var contractLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var perksLabel: UILabel!
    
    var detailItem: Offer? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let offer: Offer = self.detailItem {
            if let title = self.titleLabel {
                title.text = offer.jobTitle
            }
            if let description = self.descriptionLabel {
                description.text = offer.jobDescription
            }
            if let date = self.dateLabel {
                date.text = dateToString(offer.startDate)
            }
            if let hire = self.hireLabel {
                hire.text = offer.hire
            }
            if let contract = self.contractLabel {
                contractLabel.text = offer.contract
            }
            if let jobTime = self.timeLabel {
                jobTime.text = offer.jobTime
            }
            if let salary = self.salaryLabel {
                salaryLabel.text = "\(String(offer.salary)) XPF"
            }
            if let perks = self.perksLabel {
                perks.text = offer.perks
            }
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return dateFormatter.stringFromDate(date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
