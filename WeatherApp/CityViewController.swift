//
//  MealViewController.swift
//  WeatherApp
//
//  Created by aa001 on 11/8/17.
//

import UIKit
import os.log

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    var cityIndex: Int?
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var hourlyStackView: UIStackView!
    @IBOutlet weak var dailyStackView: UIStackView!
    @IBOutlet weak var unitButton: UIBarButtonItem!
    
    var hourlyViews: [UIView] = []
    var dailyViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Model.shared.cities[cityIndex!].lastForecast + 600 <= Date().timeIntervalSince1970 {
            Model.updateForecast(cityIndex: cityIndex ?? Model.shared.cities.count, callback: handleUpdateResult)
            Model.updateWeather(cityIndex: cityIndex ?? Model.shared.cities.count, callback: handleUpdateResult)
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestures(gesture:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestures(gesture:)))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)

        
        updateUI()
    }
    
    private func updateUI() {
        unitButton.title = Model.metric ? "℃" : "℉"
        
        // Set up views if editing an existing Meal.
        if let cityIndex = cityIndex {
            let city = Model.shared.cities[cityIndex]
            var cityName = city.name
            if cityName == Model.cityName {
                cityName += " 📍"
                view.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
            } else {
                view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
            }
            navigationItem.title = cityName
            if let weather = city.current {
                currentLabel.text = weather.main
                tempLabel.text = Model.temp(weather.temp)
                highLabel.text = Model.temp(weather.high)
                lowLabel.text = Model.temp(weather.low)
                dateLabel.text = weather.timeComponents[1...2].joined(separator: " ")
                dayOfWeekLabel.text = weather.timeComponents[3]
            }
            populateHourly(city.hourly)
            populateDaily(city.daily)
        }
    }
    
    private func populateHourly(_ weatherList: [Weather]) {
        for view in hourlyViews {
            hourlyStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        print("\(weatherList.count) entries in hourly")
        for weather in weatherList {
            let view = createHourlyView(weather.timeComponents, weather.icon, Model.temp(weather.temp))
            hourlyStackView.addArrangedSubview(view)
            hourlyViews.append(view)
        }
        print("\(hourlyStackView.arrangedSubviews.count) view created for stack view")
    }
    
    private func createHourlyView(_ timeComponents: [String], _ icon: String, _ temp: String) -> UIView {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = UIColor.red
        
        let dummyLabel = UILabel()
        dummyLabel.text = " "
        dummyLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        let timeLabel = UILabel()
        timeLabel.text = "\(timeComponents[4]) \(timeComponents[6])"
        timeLabel.textAlignment = .justified
        timeLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        timeLabel.textColor = UIColor.white
        
        let iconImageView = UIImageView()
        let imageFrame = CGRect(x: 0, y: 0, width: hourlyStackView.intrinsicContentSize.width / 12, height: hourlyStackView.intrinsicContentSize.width / 12)
        iconImageView.frame = imageFrame
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.image = UIImage(named: icon)
        
        let tempLabel = UILabel()
        tempLabel.text = temp
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.preferredFont(forTextStyle: .body)
        tempLabel.textColor = UIColor.white
        
        stack.addArrangedSubview(dummyLabel)
        stack.addArrangedSubview(timeLabel)
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(tempLabel)
        
        return stack
    }

    
    private func populateDaily(_ weatherList: [Weather]) {
        for view in dailyViews {
            dailyStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for weather in weatherList {
            let view = createDailyView(weather.timeComponents, weather.icon, Model.temp(weather.high), Model.temp(weather.low))
            dailyStackView.addArrangedSubview(view)
            dailyViews.append(view)
        }
        print("\(dailyStackView.arrangedSubviews.count) view created for stack view")
    }
    
    private func createDailyView(_ timeComponents: [String], _ icon: String, _ high: String, _ low: String) -> UIView {
        let dailyView = UIView()
        dailyView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        dailyView.widthAnchor.constraint(equalToConstant: dailyStackView.intrinsicContentSize.width).isActive = true
        
        let timeLabel = UILabel()
        timeLabel.text = timeComponents[3]
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        timeLabel.textColor = UIColor.white
        timeLabel.sizeToFit()
        
        dailyView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: timeLabel.superview!.leadingAnchor, constant: 8).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: timeLabel.superview!.centerYAnchor).isActive = true
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.image = UIImage(named: icon)

        dailyView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: iconImageView.superview!.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: iconImageView.superview!.centerYAnchor).isActive = true
        iconImageView.sizeToFit()
        
        let lowLabel = UILabel()
        lowLabel.text = low
        lowLabel.textAlignment = .right
        lowLabel.font = UIFont.preferredFont(forTextStyle: .body)
        lowLabel.textColor = UIColor.blue
        lowLabel.sizeToFit()
        
        dailyView.addSubview(lowLabel)
        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        lowLabel.trailingAnchor.constraint(equalTo: lowLabel.superview!.trailingAnchor, constant: -8).isActive = true
        lowLabel.centerYAnchor.constraint(equalTo: lowLabel.superview!.centerYAnchor).isActive = true
        
        let highLabel = UILabel()
        highLabel.text = high
        highLabel.textAlignment = .right
        highLabel.font = UIFont.preferredFont(forTextStyle: .body)
        highLabel.textColor = UIColor.red
        highLabel.sizeToFit()
        
        dailyView.addSubview(highLabel)
        highLabel.translatesAutoresizingMaskIntoConstraints = false
        highLabel.trailingAnchor.constraint(equalTo: lowLabel.trailingAnchor, constant: -32).isActive = true
        highLabel.centerYAnchor.constraint(equalTo: highLabel.superview!.centerYAnchor).isActive = true
        
        return dailyView
    }

    func handleUpdateResult(_ success: Bool, _ message: String) {
        updateUI()
        if !success {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func switchUnit(_ sender: UIBarButtonItem) {
        Model.metric  = !Model.metric
        sender.title = Model.metric ? "℃" : "℉"
        updateUI()
    }
    @objc func respondToSwipeGestures(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                if cityIndex != Model.shared.cities.count - 1 {
                    cityIndex! += 1
                }
                print("swipe right \(cityIndex!)")
            case .right:
                if cityIndex != 0 {
                    cityIndex! -= 1
                }
                print("swipe left \(cityIndex!)")
            default:
                break
            }
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.view.alpha = 0.5
        })
        
        updateUI()
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.view.alpha = 1.0
        })
    }

    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cityIndex = cityIndex {
            let count = Model.shared.cities[cityIndex].daily.count
            print("valid cityIndex with \(count) entries in section \(section)")
            return count
        } else {
            print("City View has no index")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("DailyTableView called")
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "DailyTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DailyTableViewCell else {
            fatalError("The dequeued cell is not an instance of DailyTableViewCell.")
        }
        
        cell.dayLabel.text = "Day \(indexPath.row)"
        return cell
    }
    
    

    
}

