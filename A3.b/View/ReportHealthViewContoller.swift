//
//  ReportHealthViewContoller.swift
//  A3.b
//
//  Created by Hongyu Lin on 3/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ReportHealthViewContoller: UIViewController {

    var person: Person?
    @IBOutlet weak var healthBarChartView: BarChartView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var ref = Database.database().reference().child("RaspberryRepository")
    var personList: [Person?] = []
    var figureList: [Figure?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        backgroundImageView.image = UIImage(named: "background")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        ref.child(person!.raspberryID!).child("member").observeSingleEvent(of: .value) { (snapShot) in
            if let items = snapShot.value as? [String: AnyObject]{
                for item in items{
                    let userID = item.value["userID"] as! Int
                    let name = item.value["name"] as! String
                    let email = item.value["email"] as! String
                    let password = item.value["password"] as! String
                    let gender = item.value["gender"] as! String
                    let portrait = item.value["portrait"] as! String
                    let height = item.value["height"] as! String
                    let weight = item.value["weight"] as! String
                    let dob = item.value["dob"] as! Double
                    let raspberry = item.value["raspberryID"] as! String
                    let registerDate = item.value["registerDate"] as! Double
                    var bodyData: [BodyFeature] = []
                    if let itemData = item.value["data"] as? [String: AnyObject]{
                        var bodyFeature: BodyFeature?
                        for oneData in itemData{
                            let date = oneData.value["created_date"] as! Double
                            let photo = oneData.value["photo"] as! String
                            let height = oneData.value["height"] as! Double
                            let weight = oneData.value["wight"] as! Double
                            let photoID = oneData.value["photoID"] as! String
                            let id = oneData.value["userID"] as! Int
                            bodyFeature = BodyFeature(user_id: id, dateTime: date, height: height, weight: weight, photo: photo, photoID: photoID)
                            bodyData.append(bodyFeature!)
                        }
                    }
                    let person = Person(user_id: userID, email: email, name: name, password: password, dob: dob,  portrait: portrait, gender: gender, registerDate: registerDate, height: height, weight: weight, raspberryID: raspberry, data: bodyData)
                    self.personList.append(person)
                }
                self.figureCalculator()
                self.setChart()
            }
        }
    }
    
    // calculate chart used data and save them to a list
    func figureCalculator(){
        for person in personList{
            let height = (Double(person!.height!)!/100) * 6
            let weight = Double(person!.weight!)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.dob)!)))
            let age = Calendar.current.component(.year, from: Date()) - year!
            let bmi = weight! / (height * height)
            let grade = (1 - abs(bmi - 21.7)/21.7) * 100
            print(grade)
            let figure = Figure(height * 100,weight,age,bmi,person?.name,person?.portrait, grade)
            figureList.append(figure)
        }
    }
    
    // set barchart
    func setChart() {
        var nameList: [String?] = []
        var colorList: [UIColor?] = []
        var dataEntries: [BarChartDataEntry] = []
        var xList: [Double] = []
        var x = 1
        for figure in figureList{
            xList.append(Double(x))
            nameList.append(figure?.name)
            x = x + 1
        }
        for i in 0 ..< figureList.count{
            colorList.append(self.setColor(value: (figureList[i]?.grade)!))
            let dataEntry = BarChartDataEntry(x: Double(xList[i]), y: (figureList[i]?.grade)!)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Health Grade")
        chartDataSet.colors = colorList as! [NSUIColor]
        let chartData = BarChartData(dataSet: chartDataSet)
        healthBarChartView.data = chartData
        
        healthBarChartView.leftAxis.axisMinimum = 0
        healthBarChartView.leftAxis.axisMaximum = 100
        healthBarChartView.leftAxis.drawGridLinesEnabled = false
        healthBarChartView.rightAxis.enabled = false
        healthBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: nameList as! [String])
        healthBarChartView.xAxis.granularity = 1
        healthBarChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
    // set the bar colour based on the different values
    func setColor(value: Double) -> UIColor{
        if(value < 60){
            return UIColor.red
        }
        else if(value < 80 && value >= 60){
            return UIColor.orange
        }
        else if(value >= 80){
            return UIColor.green
        }
        else { //In case anything goes wrong
            return UIColor.black
        }
    }

}
