import Foundation
// Define a simple health status model
struct HealthStatus: Codable, Identifiable {
    var id = UUID() // Added for ForEach compatibility
    var status: String
    var version: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case version
    }
}

class HealthRest: ObservableObject {
    @Published var healthStatus: HealthStatus?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchHealthData(url: String) {
        guard let url = URL(string: url) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 
                      (200...299).contains(httpResponse.statusCode) else {
                    self?.errorMessage = "Server error: \(String(describing: (response as? HTTPURLResponse)?.statusCode ?? 0))"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(HealthStatus.self, from: data)
                    self?.healthStatus = decodedData
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                }
            }
        }.resume()
    }
}