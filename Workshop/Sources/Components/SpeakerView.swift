//
//  SpeakerView.swift
//  Workshop
//
//  Created by Stefano Mondino on 04/04/24.
//

import Foundation
import SwiftUI

struct SpeakerView: View {
    @ObservedObject var viewModel: SpeakerViewModel
    let avatarSize: CGSize
    
    init(viewModel: SpeakerViewModel,
         avatarSize: CGSize = .init(width: 30, height: 30)) {
        self.viewModel = viewModel
        self.avatarSize = avatarSize
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            CachedAsyncImage(url: viewModel.image,
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: avatarSize.width, height: avatarSize.height)
                    .clipShape(Circle())
            },
                       placeholder: {
                ZStack {
                    ProgressView()
                }
                .frame(width: avatarSize.width, height: avatarSize.height)
            })
            Text(viewModel.title)
                .font(Fonts.Barlow.medium.swiftUIFont(size: 12))
                .foregroundStyle(Color(.text))
            
        }
    }
}

class SpeakerViewModel: ObservableObject, Identifiable {
    var id: String
    @Published var title: String
    @Published var image: URL?
//    @Published var subtitle: String
    init(speaker: Speaker) {
        title = speaker.name
        id = speaker.code
        self.image = speaker.avatar
//        subtitle = talk.abstract
    }
}

#Preview {
    VStack {
        SpeakerView(viewModel: .init(speaker:
                .init(code: "MND",
                      name: "Stefano Mondino",
                      avatar: .init(string: "https://imgflip.com/s/meme/The-Most-Interesting-Man-In-The-World.jpg"))))
        SpeakerView(viewModel: .init(speaker:
                .init(code: "MND",
                      name: "Stefano Mondino",
                      avatar: .init(string: "https://imgflip.com/s/meme/The-Most-Interesting-Man-In-The-World.jpg"))))
    }
}
