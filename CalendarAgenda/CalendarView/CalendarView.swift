//
//  CalendarView.swift
//  CalendarAgenda
//
//  Created by Munna on 16/03/19.
//  Copyright © 2019 GravetyTech. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.black
    static var monthViewBtnRightColor = UIColor.black
    static var monthViewBtnLeftColor = UIColor.black
    static var activeCellLblColor = UIColor.black
    static var activeCellLblColorHighlighted = UIColor.white
    static var weekdaysLblColor = UIColor.black
    
   
}

class CalenderView: UIView {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex : Int = 0
    var currentYear : Int = 0
    var presentMonthIndex : Int = 0
    var presentYear : Int = 0
    var todaysDate : Int = 0
    var firstWeekDayOfMonth : Int = 0   //(Sunday-Saturday 1-7)
    
    let monthView: MonthView = {
        let aView = MonthView()
        aView.translatesAutoresizingMaskIntoConstraints=false
        return aView
    }()
    
    let weekdaysView : WeekdaysView = {
        let aView = WeekdaysView()
        aView.translatesAutoresizingMaskIntoConstraints=false
        return aView
    }()
    
    let colMonthDate : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let colMonthDate = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        colMonthDate.showsHorizontalScrollIndicator = false
        colMonthDate.translatesAutoresizingMaskIntoConstraints = false
        colMonthDate.backgroundColor = UIColor.clear
        colMonthDate.allowsMultipleSelection = false
        return colMonthDate
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func changeTheme() {
        colMonthDate.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear = currentYear
        
        setupViews()
        
        colMonthDate.delegate = self
        colMonthDate.dataSource = self
        colMonthDate.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(colMonthDate)
        colMonthDate.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        colMonthDate.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        colMonthDate.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        colMonthDate.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

class dateCVCell: UICollectionViewCell {
    
    let lblDate: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(lblDate)
        lblDate.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lblDate.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lblDate.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lblDate.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension CalenderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor = UIColor.clear
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden = false
            cell.lblDate.text="\(calcDate)"
            cell.lblDate.textColor = Style.activeCellLblColor
//            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
//                cell.isUserInteractionEnabled=false
//                cell.lblDate.textColor = UIColor.lightGray
//            } else {
//                cell.isUserInteractionEnabled=true
//                cell.lblDate.textColor = Style.activeCellLblColor
//            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

extension CalenderView : MonthViewDelegate {
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        
        currentMonthIndex = monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        colMonthDate.reloadData()
        
//        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
}
//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
