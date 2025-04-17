import Foundation

struct AnalyticsInterface: Codable, Identifiable {
    var id = UUID()
    var status: String
    var version: String?

    enum CodingKeys: String, CodingKey {
        case status
        case version
    }
}

class AnalyticsRest: ObservableObject {
    @Published var healthStatuses: [String: AnalyticsInterface] = [:]
    @Published var loadingURLs: Set<String> = []
    @Published var errorMessages: [String: String] = [:]

    func fetchHealthData(url: String) {
        let baseurl = url
        let healthEndpoint = url.hasSuffix("/") ? "v3/" : "/rest/health"
        print(baseurl)
        let endPoint = baseurl + healthEndpoint
        print(endPoint)
        guard let url = URL(string: endPoint) else {
            errorMessages[url] = "Invalid URL"
            return
        }
        let urlString = url.absoluteString
        print(urlString)
        loadingURLs.insert(urlString)
        errorMessages[urlString] = nil

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.loadingURLs.remove(urlString)

                if let error = error {
                    self?.errorMessages[urlString] = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ... 299).contains(httpResponse.statusCode)
                else {
                    self?.errorMessages[urlString] = "Server error: \(String(describing: (response as? HTTPURLResponse)?.statusCode ?? 0))"
                    return
                }

                guard let data = data else {
                    self?.errorMessages[urlString] = "No data received"
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(AnalyticsInterface.self, from: data)
                    self?.healthStatuses[urlString] = decodedData
                } catch {
                    self?.errorMessages[urlString] = "Decoding error: \(error.localizedDescription)"
                    print("JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                }
            }
        }.resume()
    }
}
