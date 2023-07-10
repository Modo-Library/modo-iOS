//
//  ReverseGeocodeViewModel.swift
//  Modo
//
//  Created by MacBook on 2023/05/08.
//

import Foundation
import Combine

final class ReverseGeocodeViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var reverseGeocodeResult = [Welcome]()
    @Published var address : String = "불러오는중"
    @Published var region : String = "불러오는중"
    
    init(){
        reverseGeocodeResult = []
    }
    var fetchGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertGeocodeSuccess = PassthroughSubject<(), Never>()
    
    var fetchReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    
    
    func fetchReverseGeocode(latitude: Double, longitude: Double) {
        
        ReverseGeocodeService.getReverseGeocode(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
            } receiveValue: { [self] (data: Welcome) in
                reverseGeocodeResult = [data]
                region = "\(data.results[0].region.area1.name) \(data.results[0].region.area2.name) \(data.results[0].region.area3.name)"
                let number2 = data.results[0].land.number2
                if number2 == "" {
                    address = "\(region) \(data.results[0].land.number1)"
                }else{
                    address = "\(region) \(data.results[0].land.number1)-\(number2)"
                }
                fetchReverseGeocodeSuccess.send()
            }.store(in: &subscription)
        print("fetchReverseGeocode")
    }
}
