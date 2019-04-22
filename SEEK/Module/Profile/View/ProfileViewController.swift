//
//  ProfileViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

import Entity
import FirebaseStorage
import RxCocoa
import RxSwift
import Shared
import SnapKit
import UIKit

class ProfileViewController: UIViewController
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    private let facultyDetailLabel = TitleWithDisclosureView(
        title: "วิศวกรรมคอมพิวเตอร์",
        icon: #imageLiteral(resourceName: "icon-faculty"),
        shouldShowDisclosureIcon: false)
    private let phoneNumberLabel = TitleWithDisclosureView(
        title: "088-888-8888",
        icon: #imageLiteral(resourceName: "icon-telephone"),
        shouldShowDisclosureIcon: false)
    private let transactionDetailLabel = TitleWithDisclosureView(
        title: "ข้อมูลการเงิน",
        icon: #imageLiteral(resourceName: "icon-payment") )
    private let myOrderLabel = TitleWithDisclosureView(
        title: "คำขอของฉัน",
        icon: #imageLiteral(resourceName: "icon-my-request") )
    private let myDeliverLabel = TitleWithDisclosureView(
        title: "การส่งของฉัน",
        icon: #imageLiteral(resourceName: "icon-my-deliver") )
    
    let imagePicker = UIImagePickerController()
    
    let userProfileBehaviorRelay = BehaviorRelay<Entity.User?>(value: nil)
    var storageRef: StorageReference!
    var currentImageURL: String?
    
    // MARK: - Disposed bag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    let presenter: ProfilePresenterType
    
    required init?(coder aDecoder: NSCoder)
    {
        self.presenter = ProfilePresenter()
        
        super.init(coder: aDecoder)
        title = "Profile"
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = Storage.storage().reference()
        
        scrollView.addSubview(facultyDetailLabel)
        scrollView.addSubview(phoneNumberLabel)
        scrollView.addSubview(transactionDetailLabel)
        scrollView.addSubview(myOrderLabel)
        scrollView.addSubview(myDeliverLabel)
        
        scrollView.alwaysBounceVertical = true
        
        addViewConstraints()
        viewConfiguration()
        bindingDataWithPresenter()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.presenter
            .loadUserProfile()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindingDataWithPresenter()
    {
        self.presenter
            .userProfileObservable
            .do(
                onNext: { [weak self] in
                    self?.userProfileBehaviorRelay.accept($0) })
            .do(
                onNext: { [weak self] in
                    self?.nameLabel.text = "\($0?.firstname ?? "") \($0?.lastname ?? "")"
                    self?.studentIDLabel.text = $0?.userId
                    self?.facultyDetailLabel.title = $0?.faculty ?? ""
                    self?.phoneNumberLabel.title = $0?.telphone ?? ""
                    self?.currentImageURL = $0?.image ?? "" })
            .subscribe(
                onNext: { [weak self] _ in
                    self?.loadFromFirebase() })
            .disposed(by: disposeBag)
        
        selectPictureButton
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] _ in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        self.present(self.imagePicker, animated: true, completion: nil)
                    } })
            .disposed(by: disposeBag)
        
        transactionDetailLabel
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] in
                    self.presenter
                        .navigateToMyTransactionDetail(
                            from: self) })
            .disposed(by: disposeBag)
        
        myOrderLabel
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] in
                    self.presenter
                        .navigateToMyRequestHistory(from: self) })
            .disposed(by: disposeBag)
        
        myDeliverLabel
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] in
                    self.presenter
                        .navigateToMyDeliveryHistory(from: self) })
            .disposed(by: disposeBag)
        
        logoutButton
            .rx
            .tap
            .subscribe(
                onNext: { [unowned self] in
                    self.presenter.navigateToLogin(from: self) })
            .disposed(by: disposeBag)
    }
    
    private func viewConfiguration()
    {
        //Image picker setting
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        logoutButton.layer.cornerRadius = 3
        logoutButton.layer.shadowRadius = 3
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    // MARK: Constraints
    
    private func addViewConstraints()
    {
        facultyDetailLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalToSuperview()
                $0
                    .width
                    .equalToSuperview()
                $0
                    .centerX
                    .equalToSuperview() }
        
        phoneNumberLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalTo(facultyDetailLabel.snp.bottom)
                $0
                    .width
                    .equalToSuperview()
                $0
                    .centerX
                    .equalToSuperview() }
        
        transactionDetailLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalTo(phoneNumberLabel.snp.bottom)
                $0
                    .width
                    .equalToSuperview()
                $0
                    .centerX
                    .equalToSuperview() }
        
        myOrderLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalTo(transactionDetailLabel.snp.bottom)
                $0
                    .width
                    .equalToSuperview()
                $0
                    .centerX
                    .equalToSuperview() }
        
        myDeliverLabel
            .snp
            .makeConstraints {
                $0
                    .top
                    .equalTo(myOrderLabel.snp.bottom)
                $0
                    .bottom
                    .equalToSuperview()
                $0
                    .width
                    .equalToSuperview()
                $0
                    .centerX
                    .equalToSuperview() }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
        
        guard let studentId = self.userProfileBehaviorRelay.value?.userId else
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
        
        let imgRef = storageRef.child("user-profile/" + studentId + "_" + randomString(20) + ".jpg")
        
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
                
                self.presenter.updateUserImage(imageURL: imageURL) }
        }
        profileImageView.image = currentImage
    }
    
    func loadFromFirebase()
    {
        guard let url = URL(string: self.currentImageURL ?? "") else
        {
            return
        }
        
        if let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.image = image
        }
        else
        {
            self.profileImageView.image = #imageLiteral(resourceName: "icon-user")
            profileImageView.contentMode = .scaleAspectFit
        }
    }
    
    func randomString(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
