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
        v.textColor = UIColor(named: "AccentColor")
        v.textAlignment = .center
        v.font = UIFont(name: "MuseoModerno-Bold", size: 32)
        //Don't limit text
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    private lazy var albumCover: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 100
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return v
    }()
    
    private lazy var nextAlbumCover: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 100
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        v.alpha = 0
        return v
    }()
    
    private lazy var progressBar: UISlider = {
        let v = UISlider()
        v.thumbTintColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(progressScrubbed(_:)), for: .valueChanged)
        return v
    }()
    
    private lazy var elapsedTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.font = .systemFont(ofSize: 14, weight: .light)
        v.font = UIFont(name: "MuseoModerno-Medium", size: 14)
        v.text = "00:00"
        //Don't limit text
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.font = .systemFont(ofSize: 14, weight: .light)
        v.font = UIFont(name: "MuseoModerno-Medium", size: 14)
        v.text = "00:00"
        //Don't limit text
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    private lazy var songNameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.font = .systemFont(ofSize: 16, weight: .bold)
        v.font = UIFont(name: "MuseoModerno-Medium", size: 16)
        //Don't limit text
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    private lazy var artistLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.font = .systemFont(ofSize: 16, weight: .light)
        v.font = UIFont(name: "MuseoModerno-Light", size: 16)
        //Don't limit text
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor = 0.5
        return v
    }()
    
    private lazy var previousButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        v.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPrevious(_:)), for: .touchUpInside)
        return v
    }()
    
    private lazy var playPauseButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        v.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapPlayPause(_:)), for: .touchUpInside)
        return v
    }()
    
    private lazy var nextButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        v.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: config), for: .normal)
        v.addTarget(self, action: #selector(didTapNext(_:)), for: .touchUpInside)
        return v
    }()
    
    private lazy var controlStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .equalSpacing
        v.spacing = 20
        return v
    }()
    
    private var player = AVAudioPlayer()
    private var nextPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var playingIndex = 0
    private var crossfadeTimer: Timer?
    private let crossfadeDuration: TimeInterval = 5.0
    private var isAutomaticTransition = false
    private var isCrossfadeScheduled = false
    
    init(album: Album) {
        self.album = album
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        albumName.text = album.name
        albumCover.image = UIImage(named: album.songs[playingIndex].image)
        setupPlayer(song: album.songs[playingIndex])
        
        [albumName, songNameLabel, artistLabel, elapsedTimeLabel, remainingTimeLabel].forEach{ (v) in
            v.textColor = UIColor(named: "SecondaryAccentColor")
        }
        
        [albumName, albumCover, nextAlbumCover, songNameLabel, artistLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controlStack].forEach{ (v) in
            addSubview(v)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // album name
        NSLayoutConstraint.activate([
            albumName.leadingAnchor.constraint(equalTo: leadingAnchor),
            albumName.trailingAnchor.constraint(equalTo: trailingAnchor),
            albumName.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        ])
        
        // album cover
        NSLayoutConstraint.activate([
            albumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            albumCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            albumCover.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 32),
            albumCover.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
        ])
        
        // next album cover
        NSLayoutConstraint.activate([
            nextAlbumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextAlbumCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextAlbumCover.topAnchor.constraint(equalTo: albumName.bottomAnchor, constant: 32),
            nextAlbumCover.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
        ])
        
        // song name
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            songNameLabel.topAnchor.constraint(equalTo: albumCover.bottomAnchor, constant: 16)
        ])
        
        // artist label
        NSLayoutConstraint.activate([
            artistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            artistLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8)
        ])
        
        // progress bar
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8)
        ])
        
        // elapsed time
        NSLayoutConstraint.activate([
            elapsedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ])
        
        // remaining time
        NSLayoutConstraint.activate([
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ])
        
        // control stack
        NSLayoutConstraint.activate([
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            controlStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else {
            return
        }
        
        isCrossfadeScheduled = false
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }
        
        songNameLabel.text = song.name
        artistLabel.text = song.artist
        albumCover.image = UIImage(named: album.songs[playingIndex].image)
        
        do {
            if nextPlayer == nil {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                player.prepareToPlay()
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
            } else {
                nextPlayer = try AVAudioPlayer(contentsOf: url)
                nextPlayer?.delegate = self
                nextPlayer?.prepareToPlay()
                nextPlayer?.volume = 0
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        nextPlayer?.stop()
        timer?.invalidate()
        timer = nil
        crossfadeTimer?.invalidate()
        crossfadeTimer = nil
        isAutomaticTransition = false
        isCrossfadeScheduled = false
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    @objc private func updateProgress() {
        progressBar.value = Float(player.currentTime)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
        
        // Check if we need to start crossfade
        if remainingTime <= crossfadeDuration && !isCrossfadeScheduled && !isAutomaticTransition {
            isCrossfadeScheduled = true
            prepareNextTrack()
        }
    }
    
    private func prepareNextTrack() {
        let nextIndex = (playingIndex + 1) >= album.songs.count ? 0 : playingIndex + 1
        
        guard let url = Bundle.main.url(forResource: album.songs[nextIndex].fileName, withExtension: "mp3") else {
            return
        }
        
        // Set up next album cover
        nextAlbumCover.image = UIImage(named: album.songs[nextIndex].image)
        nextAlbumCover.alpha = 0
        
        do {
            nextPlayer = try AVAudioPlayer(contentsOf: url)
            nextPlayer?.delegate = self
            nextPlayer?.volume = 0.0
            nextPlayer?.prepareToPlay()
            startCrossfade()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func startCrossfade() {
        guard let nextPlayer = nextPlayer else { return }
        
        isAutomaticTransition = true
        nextPlayer.play()
        
        // Calculate the number of steps for smooth crossfade
        let steps = 50
        let volumeStep = 1.0 / Float(steps)
        let timeStep = crossfadeDuration / Double(steps)
        
        var currentStep = 0
        
        crossfadeTimer?.invalidate()
        crossfadeTimer = Timer.scheduledTimer(withTimeInterval: timeStep, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            currentStep += 1
            
            // Fade out current track and cover
            self.player.volume = 1.0 - (Float(currentStep) * volumeStep)
            self.albumCover.alpha = CGFloat(1.0 - (Float(currentStep) * volumeStep))
            
            // Fade in next track and cover
            nextPlayer.volume = Float(currentStep) * volumeStep
            self.nextAlbumCover.alpha = CGFloat(Float(currentStep) * volumeStep)
            
            if currentStep >= steps {
                timer.invalidate()
                self.crossfadeTimer = nil
                
                // Stop current player
                self.player.stop()
                
                // Set up next track as current
                self.player = nextPlayer
                self.nextPlayer = nil
                self.playingIndex = (self.playingIndex + 1) >= self.album.songs.count ? 0 : self.playingIndex + 1
                
                // Update UI
                self.songNameLabel.text = self.album.songs[self.playingIndex].name
                self.artistLabel.text = self.album.songs[self.playingIndex].artist
                
                // Swap album covers
                self.albumCover.image = self.nextAlbumCover.image
                self.albumCover.alpha = 1.0
                self.nextAlbumCover.alpha = 0
                
                // Reset progress bar for new track
                self.progressBar.value = Float(self.crossfadeDuration)
                self.progressBar.maximumValue = Float(self.player.duration)
                
                self.isAutomaticTransition = false
                self.isCrossfadeScheduled = false
            }
        }
    }
    
    @objc private func progressScrubbed(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    @objc private func didTapPrevious(_ sender: UIButton) {
        isAutomaticTransition = false
        isCrossfadeScheduled = false
        crossfadeTimer?.invalidate()
        crossfadeTimer = nil
        nextPlayer?.stop()
        nextPlayer = nil
        
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = album.songs.count - 1
        }
        setupPlayer(song: album.songs[playingIndex])
        albumCover.image = UIImage(named: album.songs[playingIndex].image)
        albumCover.alpha = 1.0
        nextAlbumCover.alpha = 0
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapPlayPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func didTapNext(_ sender: UIButton) {
        isAutomaticTransition = false
        isCrossfadeScheduled = false
        crossfadeTimer?.invalidate()
        crossfadeTimer = nil
        nextPlayer?.stop()
        nextPlayer = nil
        
        playingIndex += 1
        if playingIndex >= album.songs.count {
            playingIndex = 0
        }
        setupPlayer(song: album.songs[playingIndex])
        albumCover.image = UIImage(named: album.songs[playingIndex].image)
        albumCover.alpha = 1.0
        nextAlbumCover.alpha = 0
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secStr=timeFormatter.string(from: NSNumber(value: secs)) else {
            return "00:00"
        }
        return "\(minsString):\(secStr)"
    }
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag && player == self.player && !isCrossfadeScheduled {
            didTapNext(nextButton)
        }
    }
}
