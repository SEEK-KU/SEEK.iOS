//
//  PaymentViewController.swift
//  SEEK
//
//  Created by preawbnp on 18/4/2562 BE.
//  Copyright © 2562 oatThanut. All rights reserved.
//

import Foundation
import RxSwift
import Shared
import SnapKit
import UIKit
import FirebaseStorage

class PaymentViewController: UIViewController
{
    public var orderId: String!

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var slipImageView: UIImageView!
    @IBOutlet weak var uploadStatusView: UIView!
    @IBOutlet weak var selectSlipButton: UIButton!
    
    @IBAction func selectPictureFromPhotos(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var storageRef: StorageReference!
    var currentImageURL: String!
    
    // MARK: - Disposed bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    
    var presenter: PaymentPresenterType?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        title = "Payment"
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference()
        
        uploadStatusView.isHidden = true
        
        viewConfiguration()
        bindingDataWithPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    private func bindingDataWithPresenter()
    {
        selectSlipButton
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] _ in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } })
            .disposed(by: disposeBag)
    }
    
    private func viewConfiguration()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
}


extension PaymentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true, completion: nil)
        
        guard let currentImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            return
        }
        
        guard let orderId = presenter?.orderId else
        {
            return
        }
        
        uploadImageToFirebase(
            orderId: orderId,
            currentImage: currentImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(
        orderId: String,
        currentImage: UIImage)
    {
        guard let data = currentImage.jpegData(compressionQuality: 0.8) else
        {
            return
        }
        
        let imgRef = storageRef.child("slip/" + orderId + ".jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imgRef.putData(data, metadata: metaData) { (metadata, error) in
            guard metadata != nil else
            {
                return
            }
            
            imgRef.downloadURL { (url, error) in
                guard let imageURL = url?.debugDescription else
                {
                    return
                }
                
                self.presenter?
                    .uploadOrderSlip(
                        orderId: orderId,
                        imageURL: imageURL) }
        }
        slipImageView.image = currentImage
        uploadStatusView.isHidden = false
    }
}
