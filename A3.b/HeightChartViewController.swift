//
//  HeightChartViewController.swift
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
    
    //var showPersonDelegate: ManagePersonProtocol?
    var person: Person?
    
    var bodyfeature: [BodyFeature] = []
    let format = ["Day","Month"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        getData()
        drawLineChart(bodyfeature)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposdfsfsdfsdfse of any resources that can be recreated.
    }
    
    func getData(){
        bodyfeature = (person?.data)!
    }

    func drawLineChart(_ bodyfeature: [BodyFeature?]){
        let count = bodyfeature.count
        let heightValues = (0..<count).map{(i) -> ChartDataEntry in
            let heightVal = bodyfeature[i]?.height
            return ChartDataEntry(x: Double(i), y: heightVal!)
        }
        let weightValues = (0..<count).map{(i) -> ChartDataEntry in
            let weightVal = bodyfeature[i]?.weight
            return ChartDataEntry(x: Double(i), y: weightVal!)
        }
        let setHeight = LineChartDataSet(values: heightValues, label: "Height")
        setHeight.setColor(UIColor.blue)
        setHeight.axisDependency = .left
        let setWeight = LineChartDataSet(values: weightValues, label: "Weight")
        setWeight.setColor(UIColor.red)
        setWeight.axisDependency = .right
        
        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(setHeight)
        dataSets.append(setWeight)
        
        let data = LineChartData(dataSets: dataSets)
        self.lineChartView.data = data
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
