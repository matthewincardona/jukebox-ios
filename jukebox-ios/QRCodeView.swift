//
//  QRCodeView.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/1/24.
//

import Foundation
import SwiftUI

struct QRCodeView: View {
    private var qrCodeURL = "jukebox.matthewincardona.com"
    @State private var qrCodeImage: UIImage?

    var body: some View {
        VStack {
            Text(qrCodeURL)
                .padding()

            if let image = qrCodeImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .padding()
        .onAppear {
            qrCodeImage = QRCodeGenerator.generate(from: qrCodeURL)
        }
    }
}
