import Foundation
import Combine
import SwiftUI

class OvertimeViewModel: ObservableObject {
    @Published var isServerAvailable: Bool = true
    @Published var isDarkMode: Bool = true
    @Published var overtimes: [Overtime] = []
    @Published var statistics: [String: Int] = [:]

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchOvertimes()
    }
    
    func fetchOvertimes() {
        guard let url = URL(string: "http://vps-7c561477.vps.ovh.net:8082/api/v1/overtimes") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Overtime].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching overtimes: \(error)")
                }
            }, receiveValue: { [weak self] overtimes in
                self?.overtimes = overtimes
            })
            .store(in: &cancellables)
    }
    
    func fetchFilteredOvertimes(year: Int?, status: String?) {
        var urlComponents = URLComponents(string: "http://vps-7c561477.vps.ovh.net:8082/api/v1/overtimes/status")
        var queryItems = [URLQueryItem]()
        
        if let year = year {
            queryItems.append(URLQueryItem(name: "year", value: String(year)))
        }
    
        if let status = status, !status.isEmpty {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Overtime].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching filtered overtimes: \(error)")
                }
            }, receiveValue: { [weak self] overtimes in
                self?.overtimes = overtimes
            })
            .store(in: &cancellables)
    }
    
    func checkServerStatus() {
           let url = URL(string: "http://vps-7c561477.vps.ovh.net:8082/api/v1/overtimes")!
           var request = URLRequest(url: url)
           request.httpMethod = "HEAD"
           
           URLSession.shared.dataTask(with: request) { (_, response, error) in
               DispatchQueue.main.async {
                   if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                       self.isServerAvailable = true
                   } else {
                       self.isServerAvailable = false
                   }
               }
           }.resume()
       }
    
    @State private var overtimeDate = Date() // Use State for user input
        @State private var status = ""
        @State private var duration = 0
        @State private var errorMessage: String? = nil
    
    
    func fetchStatistics() {
            guard let url = URL(string: "http://vps-7c561477.vps.ovh.net:8082/api/v1/overtimes/statistics") else {
                print("Invalid URL")
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: OvertimeStatisticsResponse.self, decoder: JSONDecoder())
                .catch { _ in Just(OvertimeStatisticsResponse(stats: [:])) }
                .map { $0.stats }
                .receive(on: DispatchQueue.main)
                .assign(to: &$statistics)
        
        }
    
    func addOvertime(_ dto: OvertimeCreateDto, completion: @escaping (Bool) -> Void) {
            let url = URL(string: "http://vps-7c561477.vps.ovh.net:8082/api/v1/overtimes")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(dto)
                request.httpBody = jsonData
            } catch {
                print("Error encoding DTO: \(error)")
                completion(false)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error adding overtime: \(error)")
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        self.fetchOvertimes() // Refresh the list after adding
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()
        }
        
}
