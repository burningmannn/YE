//
//  Album.swift
//  YE
//
//  Created by Daniil Shutkin on 10.05.2024.
//

import Foundation

struct Album {
    var name: String
    var image: String
    var songs: [Song]
}

extension Album {
    static func get() -> [Album] {
        return [
            Album(name: "Calm", image: "calm", songs: [
                Song(name: "Body And Attitude", image: "1", artist: "DJ Freedem", favorite: false, fileName: "Body And Attitude - DJ Freedem")
            ]),
            Album(name: "Dark", image: "dark", songs: [
                Song(name: "A Simple Feeling", image: "2", artist: "Alge", favorite: false, fileName: "A Simple Feeling - Alge"),
                Song(name: "Illusions", image: "2", artist: "Anno Domini Beats", favorite: false, fileName: "Illusions - Anno Domini Beats"),
                Song(name: "Shadows", image: "2", artist: "Anno Domini Beats", favorite: false, fileName: "Shadows - Anno Domini Beats")
            ]),
            Album(name: "Dramatic", image: "dramatic", songs: [
                Song(name: "Feeling's Not Mutual", image: "3", artist: "Single Friend", favorite: false,  fileName: "Feeling's Not Mutual - Single Friend"),
                Song(name: "Kalimba", image: "3", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
            ]),
            Album(name: "Favorites", image: "favorite", songs: [
                Song(name: "Kalimba", image: "4", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
            ])
        ]
    }
}
