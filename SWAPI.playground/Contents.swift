import Foundation


struct Person: Decodable {
  let  name: String
    let films: [URL]
}
struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}
class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let peopleEndPoint = "people/"
    
    
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndPoint)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { data, _, _ in
            
            guard let data = data else { return completion(nil) }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                return completion(nil)
            }
            
        }.resume()
    }
    

//    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
//        //1) Prepare URL
//        guard let baseURL = baseURL else {return completion(nil)}
//        let peopleURL = baseURL.appendingPathComponent(peopleEndPoint)
//        let finalURL = peopleURL.appendingPathComponent("\(id)")
//        print(finalURL)
//
//        //2) Contact Server
//        URLSession.shared.dataTask(with: peopleURL) { (data, _, error) in
//
//        //3) Hamdle Errors
//            if let error = error {
//                print(error, error.localizedDescription)
//                return completion(nil)
//            }
//
//        //4) Check for data
//            guard let data = data else {return completion(nil)}
//
//        //5) Decode Person from JSON
//            do{
//                let decodeData = try JSONDecoder().decode(Person.self, from: data)
//                return completion(decodeData)
//            }catch {
//                print(error, error.localizedDescription)
//                return completion(nil)
//            }
//        }.resume()
//    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else { return completion(nil) }
                do {
                    let film = try JSONDecoder().decode(Film.self, from: data)
                    completion(film)
                } catch {
                    return completion(nil)
                }
                
            }.resume()
        }
}// End of Class

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 11) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

