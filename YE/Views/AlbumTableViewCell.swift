//
//  AlbumTableViewCell.swift
//  YE
//
//  Created by Daniil Shutkin on 10.05.2024.
//

import UIKit

final class AlbumTableViewCell: UITableViewCell {
    var album: Album? {
        didSet {
            if let album = album {
                //let url_image = URL(string: "https://www.iconninja.com/files/963/565/242/apple-blue-icon.png")!
                
                //let data = try! Data(contentsOf: url_image)
                
                //albumCover.image = UIImage(data: data)
                
                albumCover.image = UIImage(named: album.image)
                albumName.text = album.name.localized // Добавил  .localized
                //Don't limit text
                albumName.adjustsFontSizeToFitWidth = true
                albumName.minimumScaleFactor = 0.5
                songsCount.text = "\(album.songs.count) \("Songs".localizedPlural(album.songs.count))"
                //Don't limit text
                songsCount.adjustsFontSizeToFitWidth = true
                songsCount.minimumScaleFactor = 0.5
            }
        }
    }
    
    private lazy var albumCover: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 25
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return v
    }()
    
    private lazy var albumName: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "MuseoModerno-Bold", size: 18)
        v.textColor = UIColor(named: "AccentColor")
        return v
    }()
    
    private lazy var songsCount: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        v.textColor = UIColor(named: "SecondaryAccentColor")
        v.numberOfLines = 0
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [albumCover, albumName, songsCount].forEach { (v) in
            contentView.addSubview(v)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        // album Cover
        NSLayoutConstraint.activate([
            albumCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            albumCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            albumCover.widthAnchor.constraint(equalToConstant: 100),
            albumCover.heightAnchor.constraint(equalToConstant: 100),
            albumCover.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // album Name
        NSLayoutConstraint.activate([
            albumName.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
            albumName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            albumName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        // song count
        NSLayoutConstraint.activate([
            songsCount.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 16),
            songsCount.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 8),
            songsCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            songsCount.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
