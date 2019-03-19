//
//  MonthView.swift
//  CalendarAgenda
//
//  Created by Munna on 16/03/19.
//  Copyright © 2019 GravetyTech. All rights reserved.
//

import UIKit

protocol MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    
    var arrMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex : Int = 0
    var currentYear : Int = 0
    var delegate : MonthViewDelegate?
    
    let btnLeft : UIButton = {
        let btn = UIButton()
//        btn.setImage(UIImage(named: "leftArrow"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let lblName : UILabel = {
        let lbl = UILabel()
        lbl.text="Default Month Year text"
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight : UIButton = {
        let btn = UIButton()
//        btn.setImage(UIImage(named: "rightArrow"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
//        btnLeft.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text="\(arrMonths[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        lblName.text = "\(arrMonths[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}

