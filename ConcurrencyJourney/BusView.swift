//
//  BusView.swift
//  ConcurrencyJourney
//
//  Created by 신승훈 on 2024/03/26.
//

import SwiftUI

class BusManager {
    let isActive: Bool = false
    
    func changeDisplay() -> (title: String?, error: Error? ) {
        if isActive {
            return ("버스가 출발합니다", nil)
        } else {
            return (nil, URLError(.unknown))
        }
    }
}


class BusViewModel: ObservableObject {
    @Published var display: String = "버스가 출발하기 전"
    let manager = BusManager()
    
    func driving() {
        let returnedValue = manager.changeDisplay()
        if let newDisplay = returnedValue.title {
            self.display = newDisplay
        } else if let error = returnedValue.error {
            self.display = error.localizedDescription
        }
    }
}

struct BusView: View {
    @StateObject private var viewModel = BusViewModel()
    var body: some View {
        Text(viewModel.display)
            .font(.largeTitle)
            .bold()
            .onTapGesture {
                viewModel.driving()
            }
    }
}

#Preview {
    BusView()
}
