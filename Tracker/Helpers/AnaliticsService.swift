//
//  AnaliticsService.swift
//  Tracker
//
//  Created by Игорь Полунин on 24.08.2023.
//

import Foundation
import YandexMobileMetrica

final class AnaliticsService {
    static let shared = AnaliticsService()
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "52c6eb0e-49e6-4834-a2b5-9c5613bee1f6") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
}
