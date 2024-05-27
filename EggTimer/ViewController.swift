
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    func stopSound() {
        player.stop()
    }
    
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stopTimerImage: UIImageView!
    
    
    //stopTimer
    
    @IBAction func stopTimerButton(_ sender: UIButton) {
        
        stopSound()
        stopTimerImage.isHidden = true
        progressBar.setProgress(0, animated: false)
        secondsPassed = 0
        titleLabel.text = "How do you like your eggs?"
        timeLeftLabel.isHidden = true
        titleLabel.alpha = 1
        
    }
    
    //progressBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLeftLabel.isHidden = true
        progressBar.setProgress(0, animated: false)
        stopTimerImage.isHidden = true
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        
    }
    
    //eggs hardness button
    
    let eggTime: [String: Int] = ["Soft": 3,
                                  "Medium" : 4,
                                  "Hard" : 7]
    
    @IBAction func hardnessAction(_ sender: UIButton ) {
        
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {sender.alpha = 1}
        
        if progressBar.progress == 0 {
            
            timer.invalidate()
            let hardness = sender.currentTitle!
            totalTime = eggTime[hardness]!
            progressBar.setProgress(0, animated: false)
            secondsPassed = 0
            titleLabel.text = "So you like it \(hardness) huh?"
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
        } else { print("Ain't no way") }
    }
    
    //declare the selector "updateTime" in a function @objc is Objective-C
    
    @objc func updateTime() {
        if secondsPassed < totalTime {
            
            secondsPassed += 1
            progressBar.setProgress(Float(secondsPassed) / Float(totalTime), animated: true)
            print(Float(secondsPassed) / Float(totalTime))
            timeLeftLabel.isHidden = false
            
            let secondsRemaining = (Float(totalTime) - Float(secondsPassed))
            
            timeLeftLabel.text = timeString(time: TimeInterval(secondsRemaining))
            
        } else {
            
            timer.invalidate()
            titleLabel.text = String("Alright, don't choke on them!")
            playSound(soundName: "alarm_sound")
            stopTimerImage.isHidden = false
            timeLeftLabel.text = ""
            
            // animated flashing effect
            
            UIView.animate(withDuration: 0.5, delay: 0.25, options: [.repeat, .autoreverse], animations: {
                self.titleLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    // declare playSound and stopSound function
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: url!)
        self.player.play()
        self.player.numberOfLoops = -1
        
    }
    
    
    
    //change format to 00:00 (min:sec)

    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


//    let eggTime : [String : Int] = ["Soft": 300,
//                                      "Medium" : 420,
//                                      "Hard" : 720]
