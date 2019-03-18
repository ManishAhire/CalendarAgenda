//
//  WeekDaysView.swift
//  CalendarAgenda
//
//  Created by Munna on 16/03/19.
//  Copyright © 2019 GravetyTech. All rights reserved.
//

import UIKit

class WeekdaysView : UIView {
    
    let myStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        let arrDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for day in arrDays {
            let lbl = UILabel()
            lbl.text = day
            lbl.textAlignment = .center
            lbl.textColor = Style.weekdaysLblColor
            myStackView.addArrangedSubview(lbl)
        }
    }
}
