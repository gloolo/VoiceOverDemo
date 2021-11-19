//
//  ProvideInterface.swift
//  VoiceOverDemo
//
//  Created by qiang xu on 2021/11/18.
//

import Foundation
import UIKit

protocol ViewProviding {
    func contentView() -> UIView
}

class ButtonProvider: ViewProviding {
    func contentView() -> UIView {
        let btn = UIButton(type: .custom)
        btn.setTitle("Normal", for: .normal)
        btn.setTitle("HighLight", for: .highlighted)
        btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.red, for: .normal)
        return btn
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIAccessibility.post(notification: .announcement, argument: "Clicked")
        }
    }
}

struct LabelProvider: ViewProviding {
    func contentView() -> UIView {
        let label = UILabel()
        label.text = "Set Text"
        label.accessibilityLabel = "Set accessibilityLabel"
        
        return label
    }
}

struct TextFieldProvider: ViewProviding {
    func contentView() -> UIView {
        let textField = UITextField()
        textField.text = "TextField has texts"
        textField.placeholder = "I'm placeholder"
        textField.accessibilityLabel = "TextField has accessibilityLabel"
        textField.accessibilityHint = "I'm accessibility hint"
        return textField
    }
}

class TextViewProvider: ViewProviding {
    
    func contentView() -> UIView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        textView.backgroundColor = UIColor.purple
        textView.text = "I'm text view"
        textView.accessibilityLabel = "TextView has accessibilityLabel"
        textView.accessibilityHint = "I'm accessibility hint"
        textView.isScrollEnabled = false
        return textView
    }
}

struct SwitchProvider: ViewProviding {
    func contentView() -> UIView {
        UISwitch()
    }
}

class SliderProvider: ViewProviding {
    
    func contentView() -> UIView {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 100
        view.value = 50
        view.translatesAutoresizingMaskIntoConstraints = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.addTarget(self, action: #selector(slided(_:)), for: .valueChanged)
        return view
    }
    
    @objc func slided(_ slider: UISlider) {
        print("changed:\(slider.value)")
    }
}

class GroupContainerViewProvider: ViewProviding {
    func contentView() -> UIView {
        return GroupContainerView()
    }
}

class ReorderContainerViewProvider: ViewProviding {
    func contentView() -> UIView {
        return ReorderContainer()
    }
}

class BeforeReorderContainerViewProvider: ViewProviding {
    func contentView() -> UIView {
        return BeforeReorderContainer()
    }
}



class GroupContainerView: UIView {
    
    var label1: UILabel?
    var label2: UILabel?
    var toggle: UISwitch?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.text = "label1"
        addSubview(label)
        
        let label2 = UILabel()
        label2.text = "label2"
        addSubview(label2)
        
        let aSwitch = UISwitch()
        addSubview(aSwitch)
        
        label.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        label2.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.leading.equalTo(label.snp.trailing)
        }
        isAccessibilityElement = true
        aSwitch.snp.makeConstraints { make in
            make.leading.equalTo(label2.snp.trailing)
        }
        accessibilityElements = [label, label2, aSwitch]
        accessibilityHint = "tap twice to change the switch control status."
        
        self.label1 = label
        self.label2 = label2
        self.toggle = aSwitch
        
        updateAccessibilityLabel()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: (label1?.intrinsicContentSize.width ?? 0.0) +  (label2?.intrinsicContentSize.width ?? 0.0) + (toggle?.intrinsicContentSize.width ?? 0.0), height: 48)
    }
    
    override func accessibilityActivate() -> Bool {
        toggle?.setOn(!(toggle?.isOn ?? false), animated: true)
        updateAccessibilityLabel()
        return true
    }
    
    private func updateAccessibilityLabel() {
        let content = (label1?.accessibilityLabel ?? "") + (label2?.accessibilityLabel ?? "") + (toggle?.isOn == true ? "on" : "off")
        print(content)
        accessibilityLabel = content
    }
}

class BeforeReorderContainer: UIView {
    
    var label1: UILabel?
    var label2: UILabel?
    var label3: UILabel?
    var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.text = "label1"
        addSubview(label)
        
        let label2 = UILabel()
        label2.text = "label2"
        addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "label3"
        addSubview(label3)
        
        let aButton = UIButton(type: .custom)
        aButton.setTitleColor(.red, for: .normal)
        aButton.setTitle("Button", for: .normal)
        addSubview(aButton)
        
        label.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        label2.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.leading.equalTo(label.snp.trailing)
        }
        
        label3.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label2.snp.trailing)
            make.bottom.equalTo(self)
        }
        
        aButton.snp.makeConstraints { make in
            make.top.equalTo(label)
            make.leading.equalTo(label2.snp.trailing)
            make.trailing.equalTo(self)
        }

        self.label1 = label
        self.label2 = label2
        self.label3 = label3
        self.button = aButton
    }
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = (label1?.intrinsicContentSize.width ?? 0.0) +  (label2?.intrinsicContentSize.width ?? 0.0) + (button?.intrinsicContentSize.width ?? 0.0)
        let height: CGFloat = (label1?.intrinsicContentSize.height ?? 0.0) + (label3?.intrinsicContentSize.height ?? 0.0)
        return CGSize(width: width, height: height)
    }
}

class ReorderContainer: UIView {
    
    var label1: UILabel?
    var label2: UILabel?
    var label3: UILabel?
    var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.text = "label1"
        addSubview(label)
        
        let label2 = UILabel()
        label2.text = "label2"
        addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "reorder label3"
        addSubview(label3)
        
        let aButton = UIButton(type: .custom)
        aButton.setTitleColor(.red, for: .normal)
        aButton.setTitle("Button", for: .normal)
        addSubview(aButton)
        
        label.snp.makeConstraints { make in
            make.leading.centerY.equalTo(self)
        }
        
        label2.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.leading.equalTo(label.snp.trailing)
        }
        
        label3.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label2.snp.trailing)
            make.bottom.equalTo(self)
        }
        
        aButton.snp.makeConstraints { make in
            make.top.equalTo(label)
            make.leading.equalTo(label2.snp.trailing)
            make.trailing.equalTo(self)
        }

        self.label1 = label
        self.label2 = label2
        self.label3 = label3
        self.button = aButton
        
        shouldGroupAccessibilityChildren = true
        isAccessibilityElement = false
        accessibilityElements = [label, label2, label3, aButton]
    }
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = (label1?.intrinsicContentSize.width ?? 0.0) +  (label2?.intrinsicContentSize.width ?? 0.0) + (button?.intrinsicContentSize.width ?? 0.0)
        let height: CGFloat = (label1?.intrinsicContentSize.height ?? 0.0) + (label3?.intrinsicContentSize.height ?? 0.0)
        return CGSize(width: width, height: height)
    }
}

