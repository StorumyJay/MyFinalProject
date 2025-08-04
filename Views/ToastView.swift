//
//  ToastView.swift
//  FireFetch
//This is uded for notifications with our AuthView
//  Created by mikaila Akeredolu on 7/13/25.
//

import SwiftUI

struct ToastView: View {
    
    let message: String
    
    var body: some View {
        
        Text(message)
                .font(.caption)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.9))
                .cornerRadius(10)
                .shadow(radius: 10)
    }
}

#Preview {
    ToastView(message: "toast message")
}
