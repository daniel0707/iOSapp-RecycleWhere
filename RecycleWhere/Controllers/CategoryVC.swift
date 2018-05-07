//
//  CategoryVC.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 01/05/2018.
//  Copyright © 2018 Erkki Halinen & Staham Nguyen RecycleWhere. All rights reserved.
//

import UIKit
import Foundation

class CategoryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    var imageView = UIImageView()
    var categoryPickerView = UIPickerView()
    var button: CustomButton = CustomButton(size: CGSize(width: 60, height: 50), title: nil, tintColor: WHITE, fontSize: nil)
    
    //Category datasource
    var recognizedCategory : Int = 6
    var materialService = MaterialService()
    var defaults = UserDefaults.standard
    
    var categories: [String] = []
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        createBackground()
        setupImageView()
        setupPickerView()
        createButton()
        addHandlerForButton()
        
        //Fetching categories from user defaults or from server
        materialService.getCategories()
        
        guard let materialCategories = defaults.object(forKey: "materials") as? [String: Int] else {
            print("Type cast error fetching categories from user defaults")
            return
        }
        var tmpArray = Array(materialCategories.keys)
        categories = tmpArray.sorted()
    }
    
    // MARK: UI methods
    
    func createBackground() {
        let bg = UIView()
        bg.backgroundColor = LIGHT_BLUE
        bg.frame = UIScreen.main.bounds
        
        view.addSubview(bg)
    }
    
    func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        
        view.addSubview(self.imageView)
        
        let distanceToScreenHeight = (SCREEN_WIDTH - 300) / 2
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["imageView": self.imageView]
        self.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[imageView]", options: .alignAllCenterX, metrics: nil, views: views)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(distanceToScreenHeight))-[imageView]-(\(distanceToScreenHeight))-|", options: .alignAllCenterX, metrics: nil, views: views)
        let widthConstraint = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        NSLayoutConstraint.activate(verticalConstraint)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }
    
    func setupPickerView() {
        self.categoryPickerView.frame.size = CGSize(width: SCREEN_WIDTH - 40, height: SCREEN_HEIGHT / 2 - 70)
        
        view.addSubview(categoryPickerView)
        
        self.categoryPickerView.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["pickerView": self.categoryPickerView, "imageView": self.imageView] as [String : Any]
        self.categoryPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20)-[imageView]-(50)-[pickerView]", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    
    func createButton() {
        self.button.setImage(UIImage(named: "logo"), for: .normal)
        self.button.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(self.button)
        
        let distanceToScreenHeight = SCREEN_WIDTH / 2 - 25
        
        self.button.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["pickerView": self.categoryPickerView, "button": self.button] as [String : Any]
        self.button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[pickerView]-(>=20)-[button]-(20)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(distanceToScreenHeight))-[button]-(\(distanceToScreenHeight))-|", options: .alignAllCenterX, metrics: nil, views: views)
        let widthConstraint = NSLayoutConstraint(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let heightConstraint = NSLayoutConstraint(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        NSLayoutConstraint.activate(verticalConstraint)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
    }
    
    // MARK: Add handler for button
    
    func addHandlerForButton() {
        self.button.addTarget(self, action: #selector(self.navigateToMapVC), for: .touchUpInside)
    }
    
    @objc func navigateToMapVC() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let mapVC = MapGuideVC()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // MARK: Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = categories[row]
        
        let styledTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont(name: "Georgia", size: 15.0)!, NSAttributedStringKey.foregroundColor: WHITE])
        return styledTitle
    }
}
