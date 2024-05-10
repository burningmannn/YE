//
//  Album.swift
//  YE
//
//  Created by Daniil Shutkin on 10.05.2024.
//

import Foundation

struct Album {
    var name: String
    var imageAlbum: String
    var songs: [Song]
}

extension Album {
    static func get() -> [Album] {
        return [
            Album(name: "Calm", imageAlbum: "calm", songs: [
                Song(name: "Body And Attitude", imageSong: "1", artist: "DJ Freedem", favorite: false, fileName: "Body And Attitude - DJ Freedem")
            ]),
            Album(name: "Dark", imageAlbum: "dark", songs: [
                Song(name: "A Simple Feeling", imageSong: "2", artist: "Alge", favorite: false, fileName: "A Simple Feeling - Alge"),
                Song(name: "Illusions", imageSong: "2", artist: "Anno Domini Beats", favorite: false, fileName: "Illusions - Anno Domini Beats"),
                Song(name: "Shadows", imageSong: "2", artist: "Anno Domini Beats", favorite: false, fileName: "Shadows - Anno Domini Beats")
            ]),
            Album(name: "Dramatic", imageAlbum: "dramatic", songs: [
                Song(name: "Feeling's Not Mutual", imageSong: "3", artist: "Single Friend", favorite: false,  fileName: "Feeling's Not Mutual - Single Friend"),
                Song(name: "Kalimba", imageSong: "3", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
            ]),
            Album(name: "Favorites", imageAlbum: "favorite", songs: [
                Song(name: "Kalimba", imageSong: "4", artist: "Cxdy", favorite: true,  fileName: "Kalimba - Cxdy")
            ])
        ]
    }
}
