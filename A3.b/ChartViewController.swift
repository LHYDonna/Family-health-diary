//
//  ChartViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 14/10/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    //@IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var heightView: UIImageView!
    @IBOutlet weak var weightView: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    //var showPersonDelegate: ManagePersonProtocol?
    var person: Person?
    
    var bodyfeature: [BodyFeature] = []
    //var newFeature: [BodyFeature?] = []
    let format = ["Day","Month"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        getData()
        //getXValue1()
        drawLineChart(bodyfeature)
        heightView.image = UIImage.init(named: "default")
        //let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChartViewController.imageTapped(gesture:)))
        heightView.addGestureRecognizer(tapGesture)
        heightView.isUserInteractionEnabled = true
        
        self.background.image =  UIImage.gif(name: "beach-gif")
        background.contentMode = .scaleToFill
        self.background.layer.zPosition = -1
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let imageView = gesture.view as? UIImageView {
            print("Image Tapped")
            drawLineChart(bodyfeature,1)
        }
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return format.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return format[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newFeature = getBodyFeature(format[row])
        var xAxis: [String?] = []
        let formatter = DateFormatter()
        
        if (format[row].elementsEqual("Day")){
            formatter.dateFormat = "dd"
            for feature in newFeature{
                xAxis.append(formatter.string(from: Date(timeIntervalSince1970: (feature?.dateTime)!)))
            }
        }
        if (format[row].elementsEqual("Month")){
            formatter.dateFormat = "Mon"
            for feature in newFeature{
                xAxis.append(formatter.string(from: Date(timeIntervalSince1970: (feature?.dateTime)!)))
            }
        }
        drawLineChart(newFeature)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis as! [String])
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposdfsfsdfsdfse of any resources that can be recreated.
    }
    
    func getData(){
        bodyfeature = (person?.data)!
    }

    func drawLineChart(_ bodyfeature: [BodyFeature?],_ version: Int = 0){
        let count = bodyfeature.count
        let heightValues = (0..<count).map{(i) -> ChartDataEntry in
            let heightVal = bodyfeature[i]?.height
            return ChartDataEntry(x: Double(i), y: heightVal!)
        }
        let weightValues = (0..<count).map{(i) -> ChartDataEntry in
            let weightVal = bodyfeature[i]?.weight
            return ChartDataEntry(x: Double(i), y: weightVal!)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.dob)!)))
        let age = Calendar.current.component(.year, from: Date()) - year!
        let standardValues = (0..<count).map{(i) -> ChartDataEntry in
            if (age >= 18){
                if (person?.gender?.elementsEqual("Male"))!{
                    let standardVal = (bodyfeature[i]?.height!)! - 105.0
                    return ChartDataEntry(x: Double(i), y: standardVal)
                }
                else{
                    let standardVal = (bodyfeature[i]?.height!)! - 100.0
                    return ChartDataEntry(x: Double(i), y: standardVal)
                }
            }
            else{
                  let standardVal = 8.0 + (bodyfeature[i]?.height)! * 2
                return ChartDataEntry(x: Double(i), y: standardVal)
            }
        }
       
        let setHeight = LineChartDataSet(values: heightValues, label: "Height")
        setHeight.setColor(UIColor.blue)
        setHeight.axisDependency = .left
        let setWeight = LineChartDataSet(values: weightValues, label: "Weight")
        setWeight.setColor(UIColor.red)
        setWeight.axisDependency = .right
        let setStandard = LineChartDataSet(values: standardValues, label: "Standard")
        setStandard.setColor(UIColor.yellow)
        setStandard.axisDependency = .right
        
        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        
        if (version == 0){
            dataSets.append(setHeight)
            dataSets.append(setWeight)
            dataSets.append(setStandard)
        }
        if (version == 1){
            dataSets.append(setHeight)
        }
        if (version == 2){
            dataSets.append(setWeight)
        }
        
        let data = LineChartData(dataSets: dataSets)
        self.lineChartView.data = data
    }
    
    
    func getBodyFeature(_ choice: String?) -> [BodyFeature?]{
        var newFeature: [BodyFeature?] = []
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        let yearFlag = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))

        formatter.dateFormat = "dd"
        var dayFlag = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))
        
        formatter.dateFormat = "mm"
        var monthFlag = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))

        
        // If choose by day, show the current month data, the last photo for every day
        if (choice?.elementsEqual("Day"))!{
            for data in bodyfeature{
                let curFormatter = DateFormatter()
                curFormatter.dateFormat = "mm"
                let curMonth = Int(curFormatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))
                curFormatter.dateFormat = "dd"
                let curDay = Int(curFormatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))

                if (curMonth != monthFlag){
                    break
                }
                if (curMonth == monthFlag && curDay == dayFlag){
                    newFeature.append(data)
                    dayFlag = dayFlag! - 1
                }
                if (curMonth! == monthFlag! && curDay! > dayFlag!){
                    continue
                }
                if (curMonth! == monthFlag! && curDay! < dayFlag!){
                    newFeature.append(data)
                    dayFlag = curDay! - 1
                }
            }
            return newFeature
        }
        // If choose by day, show the current year data, the last photo for every month
        if (choice?.elementsEqual("Month"))!{
            for data in bodyfeature{
                let curFormatter = DateFormatter()
                curFormatter.dateFormat = "mm"
                let curMonth = Int(curFormatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))
                curFormatter.dateFormat = "yyyy"
                let curYear = Int(curFormatter.string(from: Date(timeIntervalSince1970: (person?.data.first?.dateTime!)!)))

                if (curYear != yearFlag){
                    break
                }
                if (curYear == yearFlag && curMonth == monthFlag){
                    newFeature.append(data)
                    monthFlag = monthFlag! - 1
                }
                if (curYear! == yearFlag! && curMonth! > monthFlag!){
                    continue
                }
                if (curYear! == yearFlag! && curMonth! < monthFlag!){
                    newFeature.append(data)
                    monthFlag = curMonth! - 1
                }
            }
            return newFeature
        }
        return newFeature
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
