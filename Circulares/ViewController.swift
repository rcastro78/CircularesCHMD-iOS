//
//  ViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 22/7/23.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    var avPlayer:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    var paused:Bool = false
    
    @IBOutlet weak var videoView: UIView!
   
    override func viewWillAppear(_ animated: Bool) {
        playBackgoundVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func playBackgoundVideo() {
        if let filePath = Bundle.main.path(forResource: "video_app", ofType:"mp4") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            let player = AVPlayer(url: filePathUrl)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
                player.seek(to: CMTime.zero)
                player.play()
            }
            self.videoView.layer.addSublayer(playerLayer)
            player.play()
        }
    }


}



extension UIColor {
    static let azulColegio = UIColor(red: 0, green: 81.0/255.0, blue: 137.0/255.0,alpha: 0.5)
}


extension UIViewController {
    func ocultarTeclado() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
