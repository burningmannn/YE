//
//  Song.swift
//  YE
//
//  Created by Daniil Shutkin on 10.05.2024.
//

import Foundation

struct Song: Decodable {
    var name: String
    var image: String
    var artist: String
    var favorite: Bool
    var fileName: String
    var URL_image: String
    var URL_music: String
}
