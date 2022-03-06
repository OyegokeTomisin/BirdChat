//
//  BaseView.swift
//
//  Created by Oyegoke Oluwatomisin on 04/03/2022.
//

import UIKit

class BaseView: UIView {
    
    func setup() {
        backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
