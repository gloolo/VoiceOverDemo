//
//  ContentViewController.swift
//  VoiceOverDemo
//
//  Created by qiang xu on 2021/11/18.
//

import UIKit
import SnapKit

class ContentViewController: UIViewController {
    
    let providers: [ViewProviding]
    
    let stackView: UIStackView
    
    init(providers: [ViewProviding]) {
        self.providers = providers
        self.stackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .leading
            
            return stackView
        }()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = {
            let view = UIView()
            view.backgroundColor = UIColor.systemBackground
            return view
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contents"
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView).offset(8)
            make.top.bottom.equalTo(scrollView)
        }
        
        providers.map { $0.contentView() }.forEach { contentView in
            stackView.addArrangedSubview(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
