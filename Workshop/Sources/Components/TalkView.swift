//
//  TalkView.swift
//  Workshop
//
//  Created by Stefano Mondino on 04/04/24.
//

import Foundation
import SwiftUI

struct TalkView: View {
    @ObservedObject var viewModel: TalkViewModel
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .center, spacing: 0) {
                if viewModel.speakers.isEmpty {
                    VStack {
                        viewModel.asset.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                            
                        Text(viewModel.time)
                            .font(Fonts.Barlow.bold.swiftUIFont(size: 14))
                            .foregroundStyle(Color(.text))
                    }.padding()
                        
                } else {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.time)
                                .font(Fonts.Barlow.bold.swiftUIFont(size: 14))
                            Text(viewModel.room)
                                .font(Fonts.Barlow.medium.swiftUIFont(size: 12))
                            Spacer()
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color(.background))
                    .frame(minWidth: 72, maxHeight: .infinity)
                    .layoutPriority(1)
                    .padding(8)
                    .background(Color(.accent))
                }
                HStack {
                VStack(alignment: .leading, spacing: 8) {
                   
                        Text(viewModel.title)
                            .font(Fonts.WorkSans.bold.swiftUIFont(size: 18))
                            .foregroundStyle(Color(.title))
                        if !viewModel.speakers.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(viewModel.speakers) { speaker in
                                    SpeakerView(viewModel: speaker)
                                }
                                
                                Text(viewModel.subtitle)
                                    .font(Fonts.Barlow.regular.swiftUIFont(size: 12))
                                    .foregroundStyle(Color(.text))
                                    .lineLimit(2)
                            }
                        }
                        
                    }
                .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(2)
            }
        }.clipShape(RoundedRectangle(cornerRadius: 8.0))
                .background(RoundedRectangle(cornerRadius: 8.0)
                    .foregroundStyle(Color(.background))
                    .shadow(color: .black.opacity(0.2), radius: 3))
    }
}


class TalkViewModel: ObservableObject, Identifiable {
    @Published var title: String
    @Published var subtitle: String
    @Published var speakers: [SpeakerViewModel]
    var time: String
    var id: String
    var room: String
    let talk: Talk
    let asset: Images
    var hasDetail: Bool { !speakers.isEmpty }
    init(talk: Talk) {
        self.talk = talk
        title = talk.title
        subtitle = talk.abstract ?? ""
        id = talk.id.description
        speakers = talk.speakers.map {.init(speaker: $0) }
        room = talk.room?.name.description ?? ""
        self.asset = Assets.customLogos[talk.id % Assets.customLogos.count]
        self.time = talk.start?.formatted(date: .omitted, 
                                          time: .shortened) ?? ""
    }
}

extension TalkViewModel {
    static var mock: TalkViewModel {
        .init(talk: .init(
            id: 0,
            code: "M0CK",
                                  title: "This is a mock",
                                  abstract: "Abstract with a really meaningful content but maybe just a little bit verbose to fit in a decent amount of vertical space",
                                  duration: 40,
                                  speakers: [.init(code: "MND", name: "Stefano Mondino",
                                                   avatar: URL(string:"https://imgflip.com/s/meme/The-Most-Interesting-Man-In-The-World.jpg"))],
            room: .init(id: 1, name: "Auditorium"),
            start: .init(),
            end: .init()))
    }
}

#Preview {
    ScrollView {
        VStack {
            TalkView(viewModel: .mock)
            TalkView(viewModel: .mock)
            Spacer()
        }
        .padding()
    }
}
