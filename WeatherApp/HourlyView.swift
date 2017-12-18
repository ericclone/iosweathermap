//
//  HourlyView.swift
//  WeatherApp
//
//  Created by aa001 on 12/17/17.
//

import UIKit

@IBDesignable class HourlyView: UIView {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            updateUI()
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }
    init(weather: Weather) {
        super.init()
        self.weather = weather
        updateUI()
    }
    
    // MARK: Private Methods
    func updateUI() {
        guard weather != nil else {
            return
        }
        
    }
}
