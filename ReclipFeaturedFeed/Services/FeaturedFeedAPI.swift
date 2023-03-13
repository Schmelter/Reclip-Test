//
//  FeaturedFeedAPI.swift
//  ReclipFeaturedFeed
//

import Foundation

class FeaturedFeedAPI {

    static let shared: FeaturedFeedAPI = FeaturedFeedAPI(endpoint: endpoint)
    static let endpoint = URL(string: "https://production-api.reclip.app/shares/featured")!
    
    let endpoint: URL
    
    init(endpoint: URL) {
        self.endpoint = endpoint
    }

    /** JSON decoder configured to parse data in the API's response format. */
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601WithFractionsAllowed
        return decoder
    }()
    
    func getAllFeaturedFeeds(completion: @escaping (Result<[FeaturedFeedModel], Error>) -> Void) {

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "Failed Request. Request: \(request)\nError: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }

            do {
                var feedResponse = try self.jsonDecoder.decode([FeaturedFeedModel].self, from: data)
                // Filter out duplicate entries based on id by turning them into a Dictionary
                // based on the id
                var feedIds = Set(feedResponse.map({ featuredFeedModel in
                    return featuredFeedModel.id
                }))
                feedResponse = feedResponse.reduce(into: [ FeaturedFeedModel]()) { partialResult, featuredFeedModel in
                    if feedIds.contains(featuredFeedModel.id) {
                        feedIds.remove(featuredFeedModel.id)
                        partialResult.append(featuredFeedModel)
                    }
                }
                
                // Inject the progress, if we have them
                feedResponse = feedResponse.map { featuredFeedModel in
                    let videoProgress = UserDefaults.standard.float(forKey: featuredFeedModel.id)
                    return FeaturedFeedModel(featuredFeedModel: featuredFeedModel, videoProgress: videoProgress)
                }
                completion(.success(feedResponse))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }

        }.resume()

    }
    
    func saveToUserDefaults(idToVideoProgressDict: [String: Float]) {
        for (videoId, videoProgress) in idToVideoProgressDict {
            if (videoProgress > 0) {
                UserDefaults.standard.set(videoProgress, forKey: videoId)
            }
        }
        UserDefaults.standard.synchronize()
    }
}

extension JSONDecoder.DateDecodingStrategy {

    private static let iso8601WithFractionsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let iso8601Formatters = [Self.iso8601Formatter, Self.iso8601WithFractionsFormatter]

    static let iso8601WithFractionsAllowed: JSONDecoder.DateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        for formatter in Self.iso8601Formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string '\(dateString)'")
    })

}
