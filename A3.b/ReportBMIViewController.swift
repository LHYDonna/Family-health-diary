//
//  ReportBMIViewController.swift
//  A3.b
//
//  Created by Hongyu Lin on 3/11/18.
//  Copyright © 2018 Hongyu Lin. All rights reserved.
//

import UIKit
import Firebase
import Charts

extension UIImage {
    class func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}

class ReportBMIViewController: UIViewController {
    
    @IBOutlet weak var lineChartAdult: LineChartView!
    @IBOutlet weak var lineChartChild: LineChartView!
    @IBOutlet weak var BMIImageView: UIImageView!
    @IBOutlet weak var CBMIImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var person: Person?
    var ref = Database.database().reference().child("RaspberryRepository")
    var personList: [Person?] = []
    var bmiFigureAdult: [Figure?] = []
    var bmiFigureChild: [Figure?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        backgroundImageView.image = UIImage.gif(name: "beach-gif")
        backgroundImageView.layer.zPosition = -1
        //lineChartAdult.backgroundColor = UIColor(patternImage: UIImage(named: "AdultBMI")!)
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
                self.BMICalculator()
                self.drawLineChartAdult(self.bmiFigureAdult)
                self.drawLineChartChild(self.bmiFigureChild)
            }
        }
    }
    
    func BMICalculator(){
        for person in personList{
            let height = (Double(person!.height!)!/100) * 6
            let weight = Double(person!.weight!)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = Int(formatter.string(from: Date(timeIntervalSince1970: (person?.dob)!)))
            let age = Calendar.current.component(.year, from: Date()) - year!
            let bmi = weight! / (height * height)
            let figure = Figure(height * 100,weight,age,bmi,person?.name,person?.portrait)
            if (age >= 20){
                bmiFigureAdult.append(figure)
            }
            else{
                bmiFigureChild.append(figure)
            }
        }
        print("Child")
        print(bmiFigureChild.count)
        print("Adult")
        print(bmiFigureAdult.count)
    }
    
    func getPortraitImage(_ string: String?) -> UIImage{
        var newString = string
        if (newString!.elementsEqual("Default")){
            return UIImage.init(named: "default")!
        }
        else{
            if (newString!.first == "b"){
                newString!.remove(at: (newString?.startIndex)!)
            }
            let imageData = NSData(base64Encoded: newString!, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            return UIImage.scaleImageToSize(img: UIImage(data: imageData! as Data)!, size: CGSize(width: 20.0, height: 20.0))
        }
    }
    
    // draw a line chart for adults, set fixed x and y values
    func drawLineChartAdult(_ bodyfeature: [Figure?]){
        let count = bodyfeature.count
        let values = (0..<count).map{(i) -> ChartDataEntry in
            let heightVal = bodyfeature[i]?.height
            let weightVal = bodyfeature[i]?.weight
            let image = getPortraitImage(bodyfeature[i]?.pic)
            return ChartDataEntry(x: weightVal!, y: heightVal!, icon: image)
        }
        
        let setValues = LineChartDataSet(values: values, label: "Adults")
        setValues.setColor(UIColor.blue)
        setValues.lineWidth = 0.0
        setValues.drawIconsEnabled = true
        
        let data = LineChartData(dataSet: setValues)
        
        self.lineChartAdult.xAxis.axisMinimum = 40.0
        self.lineChartAdult.xAxis.axisMaximum = 180.0
        self.lineChartAdult.xAxis.drawGridLinesEnabled = false
        self.lineChartAdult.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.lineChartAdult.leftAxis.axisMinimum = 140.0
        self.lineChartAdult.leftAxis.axisMaximum = 200.0
        self.lineChartAdult.leftAxis.drawGridLinesEnabled = false
        self.lineChartAdult.rightAxis.enabled = false
        
        self.lineChartAdult.data = data
        BMIImageView.image = UIImage(named: "AdultBMI")
        BMIImageView.alpha = 0.5
    }
    
    // draw a line chart for children, set fixed x and y values
    func drawLineChartChild(_ bodyfeature: [Figure?]){
        let count = bodyfeature.count
        let values = (0..<count).map{(i) -> ChartDataEntry in
            let ageVal = bodyfeature[i]?.age
            let bwiVal = bodyfeature[i]?.bwi
            let image = getPortraitImage(bodyfeature[i]?.pic)
            return ChartDataEntry(x: Double(ageVal!), y: bwiVal!, icon: image)
        }
        
        let setValues = LineChartDataSet(values: values, label: "Child")
        setValues.setColor(UIColor.blue)
        setValues.lineWidth = 0.0
        setValues.drawIconsEnabled = true
        
        let data = LineChartData(dataSet: setValues)
        
        self.lineChartChild.xAxis.axisMinimum = 0
        self.lineChartChild.xAxis.axisMaximum = 20
        self.lineChartChild.xAxis.drawGridLinesEnabled = false
        self.lineChartChild.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.lineChartChild.leftAxis.axisMinimum = 10
        self.lineChartChild.leftAxis.axisMaximum = 30
        self.lineChartChild.leftAxis.drawGridLinesEnabled = false
        self.lineChartChild.rightAxis.enabled = false
        
        self.lineChartChild.data = data
        CBMIImageView.image = UIImage(named: "ChildBMI")
        CBMIImageView.alpha = 0.5
        
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
