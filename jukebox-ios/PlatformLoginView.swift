//
//  Login.swift
//  jukebox-ios
//
//  Created by Matthew Incardona on 5/2/24.
//

import Foundation
import SwiftUI
import SpotifyWebAPI

struct PlatformLoginView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text("Start by connecting your account")
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .center, spacing: 30) {
                    Button {
                        print("Spotify button was tapped")
                    } label: {
                        Image("Spotify_Logo_CMYK_Green")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 300, height: 50)
                
                    Button {
                        print("YouTube Music button was tapped")
                    } label: {
                        Image("yt_music_full_rgb_black")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 300, height: 50)
                    
                    Button {
                        print("Apple Music button was tapped")
                    } label: {
                        Image("US-UK_Apple_Music_Listen_on_Lockup_RGB_blk_072720")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 300, height: 50)
            }
        }
        .padding(80)
    }
}

#Preview {
    PlatformLoginView()
}
