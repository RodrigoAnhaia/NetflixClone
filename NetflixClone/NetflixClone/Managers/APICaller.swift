//
//  APICaller.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 21/01/23.
//

import Foundation

struct Constants {
    static let API_Key = "5bcebe37f3050767b767d16266b4398d"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBGmzNgh014AgU1qSG108DsrbLGHY4rwI0"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    private var genreDictionary: [Int: String] = [:]
    
    init() {
        self.loadGenres { result in
            switch result {
            case .success(let genres):
                for genre in genres {
                    self.genreDictionary[genre.id!] = genre.name
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Movie DB Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
                
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Trensding Tv
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_Key)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Upcoming Movies
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Popular Movies
    func getPopular(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Top Rated Movies
    func getTopRated(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Animes
    func getAnimes(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/search/tv?api_key=\(Constants.API_Key)&language=en-US&query=Animation") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Discover Movies
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string:"\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate" ) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Search
    func search(with query: String, completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string:"\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_Key)&query=\(query)" ) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Youtube API Video Search
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>)  -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Recommendations
    func getMovieRecommendations(with movieId: Int, completion: @escaping (Result<[Title], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(movieId)/recommendations?api_key=\(Constants.API_Key)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Movie DB Movies Casts
    func getMovieCast(with movieId: Int, completion: @escaping (Result<Credits, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(movieId)/credits?api_key=\(Constants.API_Key)&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            print(String(describing: error))
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Credits.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func loadGenres(completion: @escaping (Result<[Genre], Error>)  -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/genre/movie/list?api_key=\(Constants.API_Key)&language=en-US") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
         
            do {
                let results = try JSONDecoder().decode(GenresResponse.self, from: data)
                completion(.success(results.genres))
            } catch {
                completion(.failure(APIError.failedToGetData))
                
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /// Return a String with the generes of a movie.
    ///
    /// - Parameters:
    ///     - of: the movie that will have its genres fetched.
    ///
    func getGeneresText(of title: Title) -> String {
        var str = ""
        let genres = title.genre_ids
        for g in genres {
            str += genreDictionary[g] ?? "nil"
            if g != genres.last {
                str += ", "
            }
        }
        return str
    }
}
