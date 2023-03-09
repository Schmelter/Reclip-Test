//
//  FeaturedFeedAPI.swift
//  ReclipFeaturedFeed
//

import Foundation

struct FeaturedFeedAPI {

    static let endpoint = URL(string: "https://production-api.reclip.app/shares/featured")!

    /** JSON decoder configured to parse data in the API's response format. */
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601WithFractionsAllowed
        return decoder
    }()

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
