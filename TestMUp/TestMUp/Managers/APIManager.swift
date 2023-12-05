//
//  APIManager.swift
//  TestMUp
//
//  Created by Нахид Гаджалиев on 28.04.2023.
//

import Foundation

private enum APIError: Error {
    case failedGettingData
    case failedBuildingURL
}

final class APIManager {
    private enum Constants {
        static let baseURL = R.string.constants.requestBaseUrl()
        static let ownerID = R.string.constants.requestOwnerId()
        static let albumID = R.string.constants.requestAlbumId()
        static let albumURL = "photos.get?&owner_id=\(ownerID)&album_id=\(albumID)"
        static let tokenTitle = R.string.constants.requestTokenTitle()
        static let APIVersion = R.string.constants.requestAPIVersion()
    }
    
    static let shared = APIManager()
    
    func getImages(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        guard let url = makeURL() else {
            completion(.failure(APIError.failedBuildingURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedGettingData))
                return
            }
            
            do {
                let images = try parseImages(from: data)
                completion(.success(images))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    private func makeURL() -> URL? {
        guard let token = AuthManager.shared.token else { return nil }
        let urlString = Constants.baseURL + Constants.albumURL + "\(Constants.tokenTitle)\(token)\(Constants.APIVersion)"
        
        return URL(string: urlString)
    }
    
    private func parseImages(from data: Data) throws -> [ImageModel] {
        let result = try JSONDecoder().decode(APIResponseModel.self, from: data)
        let images = result.response.items.compactMap { item -> ImageModel? in
            let urlString = item.sizes.first { $0.type.rawValue == String.z }?.url ?? String.empty
            
            return ImageModel(urlString: urlString, date: item.date, id: item.id)
        }
        return images
    }
}
