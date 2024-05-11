//
//  MediaPlayer.swift
//  YE
//
//  Created by Daniil Shutkin on 11.05.2024.
//

import UIKit
import AVKit

final class MediaPlayer: UIView {
    
    var album: Album
    
    private lazy var albumName: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = UIColor(named: "AccentColor")
        v.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return v
    }()
    
    private lazy var songCover: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 100
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return v
    }()
    
    private lazy var progressBar: UISlider = {
        let v = UISlider()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(progresScrubbed(_:)), for: .valueChanged)
        v.minimumTrackTintColor = UIColor(named: "subtitleColor")
        return v
    }()
    
    private lazy var elapsedTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = UIColor(named: "AccentColor")
        v.font = UIFont(name: "MuseoModerno-Light", size: 14)
        v.text = "00:00"
        return v
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = UIColor(named: "AccentColor")
        v.font = UIFont(name: "MuseoModerno-Light", size: 14)
        v.text = "00:00"
        return v
    }()
    
    private lazy var songNameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = UIColor(named: "AccentColor")
        v.font = UIFont(name: "MuseoModerno-Bold", size: 16)
        return v
    }()
    
    private lazy var artistLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = UIColor(named: "AccentColor")
        v.font = UIFont(name: "MuseoModerno-Light", size: 16)
        return v
    }()
    
    private lazy var previousButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        v.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        v.tintColor = UIColor(named: "SecondaryAccentColor")
        return v
    }()
    
    private lazy var playPauseButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 70)
        v.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPlayPause(_:)), for: .touchUpInside)
        v.tintColor = UIColor(named: "SecondaryAccentColor")
        return v
    }()
    
    private lazy var nextButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        v.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        v.tintColor = UIColor(named: "SecondaryAccentColor")
        return v
    }()
    
    // managing player elements
    private lazy var controlStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .equalSpacing
        v.spacing = 20
        return v
    }()
    
    private var player = AVAudioPlayer()
    private var timer: Timer?
    // index of track being played
    private var playingIndex = 0
    
    init(album: Album) {
        self.album = album
        // zero width and height
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        albumName.text = album.name
        songCover.image = UIImage(named: album.imageAlbum)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
    private func setupPlayer(song: Song) {
        // if track is not found
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else {
            return
        }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }
        
        songNameLabel.text = song.name
        artistLabel.text = song.artist
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            //play a track in the disabled state phone
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc private func updateProgress() {
        
    }
    
    // fatal error xcode
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func progresScrubbed(_ sender: UISlider) {
        
    }
    
    @objc private func didTapPrevious(_ sender: UIButton) {
        
    }
    
    @objc private func didTapPlayPause(_ sender: UIButton) {
        
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        
    }
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didTapNext(nextButton)
    }
}
