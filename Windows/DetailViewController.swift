//
//  DetailViewController.swift
//  Windows
//
//  Created by B Gay on 8/1/19.
//  Copyright © 2019 B Gay. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Date? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

