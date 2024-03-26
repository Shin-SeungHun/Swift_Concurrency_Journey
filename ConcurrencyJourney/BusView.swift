//
//  BusView.swift
//  ConcurrencyJourney
//
//  Created by 신승훈 on 2024/03/26.
//

import SwiftUI

class BusManager {
    let isActive: Bool = false
    
    /// 튜플
    func changeDisplay() -> (title: String?, error: Error? ) {
        if isActive {
            return ("버스가 출발합니다", nil)
        } else {
            return (nil, URLError(.unknown))
        }
    }
    
    /// Result
    func changeDisplay2() -> Result<String, Error> {
        if isActive {
            return .success("버스가 출발합니다")
        } else {
            return .failure(URLError(.unknown))
        }
    }
    
    /// throw
    func changeDisplay3() throws -> String {
        if isActive {
            return "버스가 출발합니다"
        } else {
            throw URLError(.unknown)
        }
    }
    
    func changeDisplay4() throws -> String {
        if isActive {
            return "버스가 출발합니다"
        } else {
            throw URLError(.unknown)
        }
    }
    
    func changeDisplayWithError() throws -> String {
        if isActive {
            return "버스가 출발합니다"
        } else {
            throw DisplayError.notDriveTime
        }
    }
}


class BusViewModel: ObservableObject {
    @Published var display: String = "버스가 출발하기 전"
    let manager = BusManager()
    
    func driving() {
        // tuple
        /*
        let returnedValue = manager.changeDisplay()
        if let newDisplay = returnedValue.title {
            self.display = newDisplay
        } else if let error = returnedValue.error {
            self.display = error.localizedDescription
        }
        */
        
        // Result
        /*
        let result = manager.changeDisplay2()
        
        switch result {
        case .success(let newDisplay):
            self.display = newDisplay
        case .failure(let error):
            self.display = error.localizedDescription
        }
        */
        
        // do catch
        /*
        do {
            let newDisplay = try manager.changeDisplay3()
            self.display = newDisplay
            
            let finalDisplay = try manager.changeDisplay4()
            self.display = finalDisplay
        } catch let error { // let error 생략가능
            self.display = error.localizedDescription
        }
        */
        
        // try?
        do {
            let newDisplay = try? manager.changeDisplay3()
            if let newDisplay = newDisplay {
                self.display = newDisplay
            } 
            
            let finalDisplay = try manager.changeDisplay4()
                self.display = finalDisplay
        } catch {
            self.display = error.localizedDescription
        }
        
    }
    
    func drivingReally() throws {
        self.display = try manager.changeDisplayWithError()
    }
}

struct BusView: View {
    @StateObject private var viewModel = BusViewModel()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some View {
        Text(viewModel.display)
            .font(.largeTitle)
            .bold()
            .onTapGesture {
                do{
                    try viewModel.drivingReally()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "버스 운행시간이 아닙니다")
                }
              
            }
            .sheet(item: $errorWrapper) { wrapper in
                    ErrorView(errorWrapper: wrapper)
            }
    }
}

#Preview {
    BusView()
}
