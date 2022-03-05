//
//  UIView+Extension.swift
//  BasePreviewProvider
//
//  Created by Oyegoke Oluwatomisin on 04/03/2022.
//

#if DEBUG && canImport(SwiftUI)
import SwiftUI

public struct BasePreviewProvider<QRview: UIView>: UIViewRepresentable {
    
    public func makeUIView(context: UIViewRepresentableContext<BasePreviewProvider<QRview>>) -> QRview {
        return QRview()
    }
    
    public func updateUIView(_ uiView: QRview, context: UIViewRepresentableContext<BasePreviewProvider<QRview>>) {
        
    }
    
    public typealias UIViewType = QRview
    init() {}
        
}

#endif
