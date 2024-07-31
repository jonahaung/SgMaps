//
//  File.swift
//  
//
//  Created by Aung Ko Min on 1/8/24.
//

import Foundation
import SwiftUI

public struct _DismissButton: View {
    
    private let isProtected: Bool
    private let title: String
    @Environment(\.dismiss) private var dismiss
    
    public init(isProtected: Bool = false, title: String = "Done") {
        self.isProtected = isProtected
        self.title = title
    }
    
    @ViewBuilder
    public var body: some View {
        if isProtected {
            Text(.init(title))
                ._comfirmationDialouge(message: "Are you sure to close?") {
                    Button("Continue to close", role: .destructive) {
                        dismiss()
                    }
                }
//                ._hidable(!presentationMode.wrappedValue.isPresented)
        } else {
            Button(.init(title), role: .cancel) {
                dismiss()
            }
        }
    }
}
