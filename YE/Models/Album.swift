//
//  Album.swift
//  YE
//
//  Created by Daniil Shutkin on 10.05.2024.
//

import Foundation

let URL_API = "https://ye-api-9ydz.onrender.com/api/songs/"

struct Album: Decodable {
    var name: String
    var image: String
    var songs: [Song]
    var URL_image: String
    
}

func getAlbumAPI() -> [Album] {
    guard let url = URL(string: URL_API) else {
        print("DEBUG: invalid URL")
        return []
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    var album: [Album] = []
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
            print("Network error: \(error.localizedDescription)")
            album = []
            return
        }
        
        guard let data = data else { return }
        
        do {
            album = try JSONDecoder().decode([Album].self, from: data)
        } catch {
            print("JSON decoding error: \(error.localizedDescription)")
            album = []
        }
    }.resume()
    
    semaphore.wait()
    
    return album
}

extension Album {
    static func get() -> [Album] {
        return getAlbumAPI()
    }
}



/*
 В этом подходе мы создаем объект DispatchSemaphore со значением 0, который будет блокировать выполнение кода до тех пор, пока не будет подан сигнал семафору { semaphore.signal() }. Затем мы запускаем URLSession задачу и возобновляем ее { task.resume() }. Когда задача завершается, мы сигнализируем семафору, что позволит продолжить выполнение кода { semaphore.wait() }.

 Обратите внимание, что этот подход может быть блокирующим, поэтому не рекомендуется использовать его в основном потоке. Кроме того, обычно рекомендуется использовать асинхронное программирование с обработчиками завершения или замыканиями, поскольку оно более эффективно и масштабируемо.
*/




//extension Album {
//    static func get() -> [Album] {
//        return [
//            Album(name: "Calm".localized, image: "calm", songs: [
//                Song(name: "Body And Attitude", image: "2", artist: "DJ Freedem", favorite: false, fileName: "Body And Attitude - DJ Freedem")
//            ]),
//            Album(name: "Dark".localized, image: "dark", songs: [
//                Song(name: "A Simple Feeling", image: "4", artist: "Alge", favorite: false, fileName: "A Simple Feeling - Alge"),
//                Song(name: "Illusions", image: "dark", artist: "Anno Domini Beats", favorite: false, fileName: "Illusions - Anno Domini Beats"),
//                Song(name: "Shadows", image: "4", artist: "Anno Domini Beats", favorite: false, fileName: "Shadows - Anno Domini Beats")
//            ]),
//            Album(name: "Dramatic".localized, image: "dramatic", songs: [
//                Song(name: "Feeling's Not Mutual", image: "1", artist: "Single Friend", favorite: false,  fileName: "Feeling's Not Mutual - Single Friend"),
//                Song(name: "Kalimba", image: "dramatic", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
//            ]),
//            Album(name: "Favorites".localized, image: "favorite", songs: [
//                Song(name: "Kalimba", image: "3", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
//            ])
//        ]
//    }
//}


//static func get() async -> [Album] {
//    guard let url = URL(string: URL_API) else {
//        print("DEBUG: invalid URL")
//        return []
//    }
//
//    do {
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            print("DEBUG: Status != 200")
//            return []
//        }
//
//        let albumFromAPI = try JSONDecoder().decode([Album].self, from: data)
//        return albumFromAPI
//
//    } catch let error as URLError {
//        print("URLError: \(error.localizedDescription)")
//    } catch {
//        // handle other errors
//        print("Error: \(error)")
//    }
//    return []
//}
