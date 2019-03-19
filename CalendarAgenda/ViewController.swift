//
//  ViewController.swift
//  CalendarAgenda
//
//  Created by Munna on 15/03/19.
//  Copyright © 2019 GravetyTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int) {
        print(monthIndex)
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var colWeekDays: UICollectionView!
    
    //MARK:- Variables
    let arrWeekDays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var arrWeekDates : [String] = []
    let today = Date()
    let dateFormater = DateFormatter()
    var currentDay = ""
    
    //    let calenderView: CalenderView = {
    //        let v = CalenderView()
    //        v.translatesAutoresizingMaskIntoConstraints=false
    //        return v
    //    }()
    @IBOutlet weak var calenderView: CalendarView!
    
    let month = MonthView()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        month.delegate = self
        dateFormater.dateFormat = "d"
        currentDay = getDayFromDate(today)
        print(currentDay)
        getCurrentWeek()
        
        
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    
    //MARK:- Get Current Week
    func getCurrentWeek() {
        
        DispatchQueue.global().async {
            let calendar = Calendar.current
            let dayOfWeek = calendar.component(.weekday, from: self.today)
            let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: self.today)!
            let days = (weekdays.lowerBound ..< weekdays.upperBound)
                .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: self.today) }
            
            for day in days {
                
                let aDay = self.getDayFromDate(day)
                self.arrWeekDates.append(aDay)
            }
            
            DispatchQueue.main.async {
                print(self.arrWeekDates)
                self.colWeekDays.reloadData()
            }
        }
    }
    
    func getDayFromDate(_ date : Date) -> String {
        return dateFormater.string(from: date)
    }
    @IBAction func actionOnOpenCalendar(_ sender: Any) {
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrWeekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/8.3, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Week", for: indexPath)
        let day = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        
        day.text = arrWeekDays[indexPath.row]
        date.text = arrWeekDates[indexPath.row]
        
        
        if currentDay == arrWeekDates[indexPath.row] {
            date.layer.cornerRadius = date.frame.width/2
            date.clipsToBounds = true
            date.backgroundColor = UIColor.green
        } else {
            date.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

