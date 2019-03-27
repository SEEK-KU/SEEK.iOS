//
//  ProfileViewController.swift
//  SEEK
//
//  Created by oatThanut on 21/1/19.
//  Copyright © 2019 oatThanut. All rights reserved.
//

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
    
    private let facultyDetailLabel = TitleWithDisclosureView(
        title: "วิศวกรรมคอมพิวเตอร์",
        icon: #imageLiteral(resourceName: "icon-close"),
        shouldShowDisclosureIcon: false)
    private let phoneNumberLabel = TitleWithDisclosureView(
        title: "088-888-8888",
        icon: #imageLiteral(resourceName: "icon-close"),
        shouldShowDisclosureIcon: false)
    private let transactionDetailLabel = TitleWithDisclosureView(
        title: "ข้อมูลการเงิน",
        icon: #imageLiteral(resourceName: "icon-close") )
    private let myOrderLabel = TitleWithDisclosureView(
        title: "คำขอของฉัน",
        icon: #imageLiteral(resourceName: "icon-close") )
    private let myDeliverLabel = TitleWithDisclosureView(
        title: "การส่งของฉัน",
        icon: #imageLiteral(resourceName: "icon-close") )
    
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.presenter
            .loadUserProfile()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func bindingDataWithPresenter()
    {
        self.presenter
            .userProfileObservable
            .subscribe(
                onNext: { [weak self] in
                    self?.nameLabel.text = "\($0?.firstname ?? "") \($0?.lastname ?? "")"
                    self?.studentIDLabel.text = $0?.userId
                    self?.facultyDetailLabel.title = $0?.faculty ?? ""
                    self?.phoneNumberLabel.title = $0?.telphone ?? ""
                    
            })
            .disposed(by: disposeBag)
    }
    
    private func viewConfiguration()
    {
        logoutButton.layer.cornerRadius = 3
        logoutButton.layer.shadowRadius = 3
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 1)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
