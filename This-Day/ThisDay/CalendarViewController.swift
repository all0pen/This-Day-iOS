//
//  ViewController.swift
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire

class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    private var shouldShowDaysOut = true
    private var animationFinished = true
    private var selectedDay: DayView!
    private var currentCalendar: Calendar?
    
    // user information 정보 넘기기
    var info: LoginInfo? = LoginInfo.shared
    
    
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    // MARK: - Life cycle
    
    // 할 일 정보 배열 리스트를 담아둘 배열
    var calendarInfo: [CalendarInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
        // ********************* 여기 **************************
        // Todo : alamofire - mycalendar 할일 전체 가져오기
        
        Alamofire.request("http://ldy.codegrapher.io/cal/calendar/list/").responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("finish")
                
                if let error: Error = response.error {
                    print("네트워크 요청 오류발생")
                    print(error.localizedDescription)
                    return
                }
                
                guard var data: Data = response.data else {
                    print("data 없음")
                    return
                }
                
                let jsonString = String(data: data, encoding: .utf8)
                print(jsonString)
                
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    self.calendarInfo = try
                        decoder.decode([CalendarInfo].self, from: data)
                    
                } catch {
                    print("JSON 디코드 오류 발생")
                    print(error.localizedDescription)
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    // *************** 다음 목적지로 보낼 것들 준비 ***************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let day: DayView = sender as? DayView {
            // sender가 day view 일 때
            
            // *************** 다른 부분 ***************
//            guard let navi: UINavigationController = segue.destination as? UINavigationController else {
//                print("목적지가 내비가 아님")
//                return
//            }
            
            guard let popup: PopUpViewController = segue.destination as? PopUpViewController else {
                print("pop up view controller가 아님")
                return
            }
            
            // ********************* 여기 **************************
            // pop up view controller로 보낼 때 date별로 분류해서 보내기
            
            popup.selectedDate = day.date
            popup.info = self.info
      
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // date별로 분류해서 pop up view controller에 정보 띄우기
            let infos = self.calendarInfo.filter({ (info) -> Bool in
                
                
                let dateString = dateFormatter.string(from:  self.selectedDay.date.convertedDate()!)
                
                return info.date == dateString
            })
            
            popup.calendarInfo = infos
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? { return currentCalendar }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.white
    }
    
    func shouldShowWeekdaysOut() -> Bool { return shouldShowDaysOut }
    
    // Defaults to true
    func shouldAnimateResizing() -> Bool { return true }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return arc4random_uniform(3) == 0 ? true : false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool { return false }
    
    // ************* 날짜 선택하면 다음 화면으로 넘어가게 함 *************
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        print("날짜 선택함" + dayView.dayLabel.text!)
        
        self.performSegue(withIdentifier: "showTodo", sender: dayView)
    }
    
    // false로 값 변경하여 날짜 제대로 보이게 함.
    func shouldSelectRange() -> Bool { return false }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
    
    func weekdaySymbolType() -> WeekdaySymbolType { return .short }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool { return false }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    // 요일 글자색 변경하는 부분
    func dayOfWeekTextColor() -> UIColor { return .white }
    
    // 요일 배경색 변경하는 부분
    func dayOfWeekBackGroundColor() -> UIColor { return .init(red: 0.3, green: 0.7, blue: 0.7, alpha:   1) }
    
    func disableScrollingBeforeDate() -> Date { return Date() }
    
    func earliestSelectableDate() -> Date { return Date() }
    
}


// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    func spaceBetweenDayViews() -> CGFloat { return 0 }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectedText
        case (.sunday, .in, _): return ColorsConfig.sundayText
        case (.sunday, _, _): return ColorsConfig.sundayTextDisabled
        case (_, .in, _): return ColorsConfig.text
        default: return ColorsConfig.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return ColorsConfig.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectionBackground
        default: return nil
        }
    }
}

// MARK: - IB Actions

extension CalendarViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        calendarView.changeDaysOutShowingState(shouldShow: sender.isOn)
        shouldShowDaysOut = sender.isOn
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    // 이전 월로 넘김
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    // 다음 월로 넘김
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else { return }
        
        var components = Manager.componentsForDate(Date(), calendar: currentCalendar) // from today
        
        components.month! += offset
        
        let resultDate = currentCalendar.date(from: components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    
    func didShowNextMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else { return }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
    
    func didShowPreviousMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else { return }
        
        let components = Manager.componentsForDate(date, calendar: currentCalendar) // from today
        
        print("Showing Month: \(components.month!)")
    }
    
}
