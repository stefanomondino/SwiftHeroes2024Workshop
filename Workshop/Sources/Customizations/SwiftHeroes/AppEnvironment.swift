//
//  AppEnvironment.swift
//  Workshop
//
//  Created by Stefano Mondino on 16/04/24.
//

import Foundation

struct AppEnvironment {
    static let shared = AppEnvironment()
    
    var baseURL: URL {
          .init(string: "https://swiftheroes.com/swiftheroes-2024/schedule/v/1.0/widgets/schedule.json") ?? .init(filePath: "")
      }
//    var baseURL2: URL {
//          .init(string: "https://flutterheroes.com/flutter-heroes-2024/schedule/v/0.8/widget/v2.json") ?? .init(filePath: "")
//      }
}

extension Assets {
    static var customLogos: [Images] = [Assets.sh1, Assets.sh2, Assets.sh3, Assets.sh4]
}
