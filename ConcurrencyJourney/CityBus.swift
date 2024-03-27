//
//  CityBus.swift
//  ConcurrencyJourney
//
//  Created by 신승훈 on 2024/03/27.
//

import SwiftUI

class CityBusManager {
    let ticket = URL(string: "https//img.icons8.com/?size=512&id=WBn88SGX4mke&format=png")!
    
    func downloadWithEscaping(completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: ticket) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, URLError(.badServerResponse))
            } else {
                guard let data = data else { return }
                
                let image = UIImage(data: data)
                completion(image, nil)
            }
        }
        .resume()
    }
}


class CityBusViewModel: ObservableObject {
    @Published var passenger: UIImage?
    
    private let busManager = CityBusManager()
    
    func busManagerImage() {
        busManager.downloadWithEscaping { [weak self] passenger, error in
            DispatchQueue.main.async {
                self?.passenger = passenger
            }
        }
    }
    
    func fetchPassengerImage() {
        
    }
}

struct CityBus: View {
    @StateObject private var viewModel = CityBusViewModel()
    
    var body: some View {
        VStack {
            if let passengerImage = viewModel.passenger {
                Image(uiImage: passengerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CityBus()
}
