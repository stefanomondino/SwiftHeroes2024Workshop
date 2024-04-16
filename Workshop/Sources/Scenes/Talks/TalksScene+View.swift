//
//  TalkListView.swift
//  Workshop
//
//  Created by Stefano Mondino on 05/04/24.
//

import Foundation
import SwiftUI

extension TalksScene {
    
    struct View: SceneView {
        @ObservedObject var viewModel: TalksScene.ViewModel
        
        var body: some SwiftUI.View {
            ScrollView {
                LazyVGrid(columns: [.init()]) {
                    ForEach(viewModel.items) { item in
                        if item.hasDetail {
                            Button(action: { viewModel.open(viewModel: item)}) {
                                TalkView(viewModel: item)
                            }
                        } else {
                            TalkView(viewModel: item)
                        }
                    }
                }
                .padding()
            }
            .onAppear { viewModel.reload() }
            .refreshable { viewModel.reload() }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(alignment: .bottom) {
                        Assets.sh3.swiftUIImage.resizable().aspectRatio(contentMode: .fit)
                        Text("talks")
                            .font(Fonts.WorkSans.bold.swiftUIFont(size: 18))
                            .foregroundStyle(Color(.accent))
                    }
                    .frame(height: 44)
                }
            }
        }
    }
}
