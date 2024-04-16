//
//  TalkDetailView.swift
//  Workshop
//
//  Created by Stefano Mondino on 08/04/24.
//

import Foundation
import SwiftUI

struct TalkDetailView: SceneView {
    @ObservedObject var viewModel: TalkDetail.ViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(Fonts.Barlow.bold.swiftUIFont(size: 24))
                           
                        HStack {
                            ForEach(viewModel.speakers) { speaker in
                                SpeakerView(viewModel: speaker)
                            }
                        }
                    }
                    
                    if !viewModel.abstract.isEmpty {
                        VStack(alignment: .leading) {
                            Text("abstract")
                                .font(Fonts.Barlow.bold.swiftUIFont(size: 12))
                                .foregroundStyle(Color(.title))
                            Text(viewModel.abstract)
                                .font(Fonts.Barlow.regular.swiftUIFont(size: 12))
                                .foregroundStyle(Color(.text))
                                
                        }
                    }
                }.padding(16)
            }
        }
    }
}

extension TalkDetailView {
    struct SpeakerView2: View {
        struct Parallelogram: Shape {
            
            var offset: CGFloat
            
            func path(in rect: CGRect) -> Path {
                let offset = min(offset, rect.maxX)
                return Path { path in
                    path.move(to: .init(x: rect.minY + offset, y: rect.minY))
                    path.addLine(to: .init(x: rect.maxX, y: rect.minY))
                    path.addLine(to: .init(x: rect.maxX - offset, y: rect.maxY))
                    path.addLine(to: .init(x: rect.minY, y: rect.maxY))
                    path.closeSubpath()
                }
            }
        }
        @ObservedObject var viewModel: SpeakerViewModel
        
        
        init(viewModel: SpeakerViewModel) {
            self.viewModel = viewModel
        }
        let sideOffset:CGFloat = 0
        let height: CGFloat = 300
        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                CachedAsyncImage(url: viewModel.image,
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: height)
                        
                        .clipShape(Rectangle())
                },
                           placeholder: {
                    ZStack {
                        ProgressView()
                    }
                    .frame(height: height)
                })
                Text(viewModel.title)
                    .font(Fonts.WorkSans.bold.swiftUIFont(size: 16))
                    .foregroundStyle(Color(.accent))
                    
                    
                    
                
            }
        }
    }
}

#Preview(body: {
    TalkDetailView(viewModel: .init(.init(id: 0, 
                                          code: "",
                                          title: "Title test talk",
                                          abstract: "Lorem Ipsum", 
                                          duration: 40,
                                          speakers: [.init(code: "MND", name: "Stefano Mondino",
                                                           avatar: URL(string:"https://imgflip.com/s/meme/The-Most-Interesting-Man-In-The-World.jpg")),
                                                     .init(code: "MND2", name: "Stefano Mondino",
                                                                      avatar: URL(string:"https://imgflip.com/s/meme/The-Most-Interesting-Man-In-The-World.jpg"))],
                                          room: nil,
                                          start: .init(),
                                          end: .init()),
                                    router: .init(container: .init())))
})
