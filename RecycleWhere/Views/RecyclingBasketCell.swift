//
//  RecyclingBasketCell.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 04/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import UIKit

class RecyclingBasketCell: UITableViewCell {
    
    var imageViewOfCategory = UIImageView()
    var titleOfCategory = UILabel()
    var numberOfItemLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupSubviewsBasedOnCategory(name: String) {
        
        let views = ["imageView": imageViewOfCategory, "categoryTitle": titleOfCategory, "numberOfItemLabel": numberOfItemLabel] as [String : Any]
        
        setupImageViewOf(category: name, views: views as! [String : UIView])
        setupTitleOf(category: name, views: views as! [String : UIView])
        setupNumberOfItemLabelOf(category: name, views: views as! [String : UIView])
    }
    
    func setupImageViewOf(category name: String, views: [String : UIView]) {
        imageViewOfCategory.image = UIImage(named: name)
        addSubview(imageViewOfCategory)
        imageViewOfCategory.translatesAutoresizingMaskIntoConstraints = false;
        imageViewOfCategory.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[imageView]", options: .alignAllCenterX, metrics: nil, views: views)
        let widthConstraint = NSLayoutConstraint(item: imageViewOfCategory, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: imageViewOfCategory, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }
    
    func setupTitleOf(category name: String, views: [String : UIView]) {
        titleOfCategory.text = name
//        titleOfCategory.textColor = WHITE
        addSubview(titleOfCategory)
        titleOfCategory.translatesAutoresizingMaskIntoConstraints = false;
        titleOfCategory.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(100)-[categoryTitle]", options: .alignAllCenterX, metrics: nil, views: views)
        let widthConstraint = NSLayoutConstraint(item: titleOfCategory, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: titleOfCategory, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }
    
    func setupNumberOfItemLabelOf(category name: String, views: [String : UIView]) {
        numberOfItemLabel.text = name
//        numberOfItemLabel.textColor = WHITE
        addSubview(numberOfItemLabel)
        numberOfItemLabel.translatesAutoresizingMaskIntoConstraints = false;
        numberOfItemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[numberOfItemLabel]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let widthConstraint = NSLayoutConstraint(item: numberOfItemLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: numberOfItemLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
