import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    // Coin selection to populate picker
    let coinList = ["Bitcoin", "Bitcoin Cash", "Litecoin", "Ethereum", "Ripple"]
    // ID's used by coinmarketcap to identify coins
    let coinListId = [1, 1831, 2, 1027, 52]
    
    // Set status bar icon colors to white
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinPicker.delegate = self
        coinPicker.dataSource = self
        // Display price of selected coin
        displayCoinData(id: coinListId[coinPicker.selectedRow(inComponent: 0)])
    }

    func numberOfComponents(in coinPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        displayCoinData(id: coinListId[row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Fetch and display coin price
    func displayCoinData(id: Int) {
        Alamofire.request("https://api.coinmarketcap.com/v2/ticker/\(id)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let coinDataJson = JSON(responseData.result.value!)
                self.priceLabel.text = "$" + String(coinDataJson["data"]["quotes"]["USD"]["price"].doubleValue)
                self.coinLabel.text = coinDataJson["data"]["name"].stringValue
            }
        }
    }
  
}

