//
//  BaseViewController.swift
//  UnsplashMobile
//
//  Created by 유철원 on 7/22/24.
//

import UIKit

class BaseViewController<View: BaseView, ViewModel: BaseViewModel>: UIViewController {
    
    var rootView: View?
    var viewModel: ViewModel?
    
    init(view: View, viewModel: ViewModel? = nil) {
        self.rootView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: ", self.self)
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configView()
        configInteraction()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: Resource.CIColor.white, shadowImage: true)
    }
    
    func configHierarchy() {
    
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        view.backgroundColor = Resource.CIColor.white
    }
    
    func bindData() {
        
    }
    
    func configInteraction() {
        
    }
    
    func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: Resource.CIColor.black]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navigationColor
        appearance.shadowImage = shadowImage ? nil : UIImage()
        appearance.shadowColor = shadowImage ? Resource.CIColor.lightGray : .clear
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
}
