//
//  PaymentViewController.swift
//  SEEK
//
//  Created by preawbnp on 17/4/2562 BE.
//  Copyright © 2562 oatThanut. All rights reserved.

import FirebaseStorage
import RxSwift
import Shared
import SnapKit
import UIKit

class TransactionViewController: UIViewController
{
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var uploadStatusView: UIView!
    @IBOutlet weak var editImageButton: UIButton!
    
    private let imagePicker = UIImagePickerController()
    
    var storageRef: StorageReference!
    var currentImageURL: String!
    
    // MARK: - Presenter
    
    var presenter: TransactionPresenterType?
    
    // MARK: - Disposed bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        title = "Transaction"
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        storageRef = Storage.storage().reference()
        
        viewConfiguration()
        bindingDataWithPresenter()
    }
    
    private func viewConfiguration()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        qrImageView.isUserInteractionEnabled = true
        uploadStatusView.isHidden = true
    }
    
    private func bindingDataWithPresenter()
    {
        presenter?
            .loadUserQR()
            .do(
                onNext: { [weak self] in
                    self?.currentImageURL = $0 })
            .subscribe(
                onNext: { [weak self] _ in
                    self?.loadFromFirebase() })
            .disposed(by: disposeBag)
        
        editImageButton
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] _ in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } })
            .disposed(by: disposeBag)
    }
}

extension TransactionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        dismiss(animated: true, completion: nil)
        
        guard let currentImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else
        {
            return
        }
        
        guard let studentId = presenter?.studentId else
        {
            return
        }
        
        uploadImageToFirebase(
            studentId: studentId,
            currentImage: currentImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(
        studentId: String,
        currentImage: UIImage)
    {
        guard let data = currentImage.jpegData(compressionQuality: 0.8) else
        {
            return
        }
        
        let imgRef = storageRef.child("payment-info/" + studentId + ".jpg")
        
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
                
                self.presenter?.uploadUserQR(imageURL: imageURL) }
        }
        qrImageView.image = currentImage
        uploadStatusView.isHidden = false
    }
    
    func loadFromFirebase()
    {
        guard let url = URL(string: self.currentImageURL ?? "") else
        {
            return
        }
        
        if let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            self.qrImageView.image = image
        }
        else
        {
            //
        }
    }
}
