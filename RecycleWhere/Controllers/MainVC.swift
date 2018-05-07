//
//  ViewController.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 18/04/2018.
//  Copyright © 2018 Staham Nguyen. All rights reserved.
//

import UIKit

class MainVC: UIViewController, XMLParserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var logo: UIImageView?
    var identifyButton: CustomButton?
    var recyclingBasketButton: CustomButton?
    
    let imagePicker = UIImagePickerController()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        createLogo()
        createIdentifyButton()
        addHandlerForIdentifyButton()
        createRecyclingBasketButton()
        addHandlerForRecyclingBasketButton()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: UI methods
    
    func createBackground() {
        let bg = UIView()
        bg.backgroundColor = LIGHT_BLUE
        bg.frame = UIScreen.main.bounds
        
        view.addSubview(bg)
    }
    
    func createLogo() {
        self.logo = UIImageView(image: UIImage(named: "logo"))
        self.logo?.tintColor = SAFFRON
        self.logo?.contentMode = .scaleAspectFit
        self.logo?.frame = CGRect(x: SCREEN_WIDTH / 2 - 100, y: SCREEN_HEIGHT / 2 - 200, width: 200, height: 200)
        
        view.addSubview(self.logo!)
    }
    
    func createIdentifyButton() {
        self.identifyButton = CustomButton(size: CGSize(width: 200, height: 50), title: "Press to Identify", tintColor: WHITE, fontSize: 30)
        view.addSubview(self.identifyButton!)
        
        self.identifyButton?.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["logo": self.logo!, "button": self.identifyButton!] as [String : Any]
        self.identifyButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[logo]-(50)-[button]", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    
    func createRecyclingBasketButton() {
        self.recyclingBasketButton = CustomButton(size: CGSize(width: 200, height: 50), title: "Recycling Basket", tintColor: WHITE, fontSize: 30)
        view.addSubview(self.recyclingBasketButton!)
        
        self.recyclingBasketButton?.translatesAutoresizingMaskIntoConstraints = false;
        let views = ["recyclingBut": self.recyclingBasketButton!, "identifyBut": self.identifyButton!]
        self.recyclingBasketButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[identifyBut]-(30)-[recyclingBut]", options: .alignAllCenterX, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraint)
    }
    
    // MARK: Add handler for button
    
    func addHandlerForIdentifyButton() {
        self.identifyButton?.addTarget(self, action: #selector(self.chooseImage), for: .touchUpInside)
    }
    
    func addHandlerForRecyclingBasketButton() {
        self.recyclingBasketButton?.addTarget(self, action: #selector(self.navigateToRecyclingBasketVC), for: .touchUpInside)
    }
    
    @objc func chooseImage() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take a photo",
                                            style: .default,
                                            handler: { action in self.takePhoto()}))
        actionSheet.addAction(UIAlertAction(title: "Choose from library",
                                            style: .default,
                                            handler: { action in self.choosePhotoFromLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func navigateToRecyclingBasketVC() {
        let recyclingBasketVC = RecyclingBasketVC()
        navigationController?.pushViewController(recyclingBasketVC, animated: true)
    }
    
    // MARK: ImagePicker
    
    func choosePhotoFromLibrary() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let squareChosenImage = chosenImage.scaleImageToSize(size: CGSize(width: 300, height: 300))
            dismiss(animated: true, completion: {
                //Call ML prediction
                self.navigateToCategoryVC(with: squareChosenImage,mlResult:  self.predictWithMagic(img: squareChosenImage))
            })
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            alertThatThereIsNoCamera()
        }
    }
    
    func alertThatThereIsNoCamera() {
        let alertVC = UIAlertController(
            title: "No camera detected",
            message: "There is no camera on your device.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // MARK: Navigate to Category VC
    
    func navigateToCategoryVC(with chosenImage: UIImage,mlResult: Int) {
        let categoryVC = CategoryVC()
        categoryVC.imageView = UIImageView(image: chosenImage)
        categoryVC.recognizedCategory = mlResult
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    // MARK: Reveal navigation bar for next VC if needed
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        // Make the navigation bar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    func buffer(from image: UIImage) -> CVPixelBuffer?{
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {return nil}
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        //noneSkipLast ?? since BGR  A ?
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    func predictWithMagic(img: UIImage)-> Int{
        let targetImageSize = CGSize(width: 256, height: 256)
        let resizedImage = img.scaleImageToSize(size: targetImageSize)
        let bufferedImage = buffer(from: resizedImage)
        
        /*
         let ciImage = CIImage(cvPixelBuffer: bufferedImage!)
         let uiImage = UIImage(ciImage: ciImage)
         */
        
        bufferedImage?.normalize()
        
        let mModel = skynetV1Upgraded()
        let mModelOutput = try? mModel.prediction(image: bufferedImage!)
        let mMOOutput = mModelOutput!.output
        /*
         print(mMOOutput["Cardboard"])
         print(mMOOutput["Glass"])
         print(mMOOutput["Metal"])
         print(mMOOutput["Paper"])
         print(mMOOutput["Plastic"])
         print(mMOOutput["Trash"])
         */
        var predictionArray = [Double]()
        predictionArray.append(mMOOutput["Cardboard"]!)
        predictionArray.append(mMOOutput["Glass"]!)
        predictionArray.append(mMOOutput["Metal"]!)
        predictionArray.append(mMOOutput["Paper"]!)
        predictionArray.append(mMOOutput["Plastic"]!)
        predictionArray.append(mMOOutput["Trash"]!)
        
        /*
         let mMOCount = mMOOutput.count
         let doublePtr = mMOOutput.dataPointer.bindMemory(to: Double.self, capacity: mMOCount)
         let doubleBuffer = UnsafeBufferPointer(start: doublePtr, count: mMOCount)
         let predictionArray = Array(doubleBuffer)
         */
        return predictionArray.index(of: predictionArray.max()!)!
        
        //return uiImage
    }
}

