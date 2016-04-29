import UIKit


    
    struct Orders{
        let id, ownId, status, currency, email, createdAt, method:String
        let blocked:Bool
        let total:Double
        let addition, fees, deduction, otherReceivers: Int
    }
class ResultViewController: UIViewController {
    
    var listaOrders = Array<Orders>()

    //IBOutlet
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.valueForKey("token") as! String
        print(token)
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://sandbox.moip.com.br/v2/orders?limit=100")!)
        request.HTTPMethod = "GET"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            if let data = data{
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            
                    let formater = NSDateFormatter()
                    formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    let formaterFinal = NSDateFormatter()
                    formaterFinal.dateFormat = "dd/MM/yyyy"

                    
                    if let orderDictionary = json["orders"] as? [NSDictionary] {
                        
                        
                        for order in orderDictionary {
                            //order
                            var currency = ""
                            if let testCurrency = order["amount"]?["currency"] as? String{
                                currency = testCurrency
                            }
                            
                            var email = ""
                            if let testEmail = order["customer"]?["email"] as? String{
                                email = testEmail
                            }
                            
                            var createdAt = ""
                            if let testCreatedAt = order["createdAt"] as? String{
                                
                                let date = formater.dateFromString(testCreatedAt)!
                                createdAt = formaterFinal.stringFromDate(date)
                                
                            }
                            var method = ""
                            if let payments = order["payments"] as? NSArray{
                                
                                if let payment  = payments.firstObject{
                                    
                                    if let instrument = payment["fundingInstrument"] as? NSDictionary{
                                        
                                        method = "\(instrument["method"]!)"
                                    }
                                }
                            }
                           

                            self.listaOrders.append(
                                Orders(id: "\(order["id"]!)",
                                    ownId: "\(order["ownId"]!)",
                                    status: "\(order["status"]!)",
                                    currency: currency,
                                    email: email,
                                    createdAt:createdAt,
                                    method:method,
                                    blocked: (order["blocked"] as? Bool)!,
                                    total: ((order["amount"]!["total"]) as? Double)!,
                                    addition: ((order["amount"]!["addition"]) as? Int)!,
                                    fees: ((order["amount"]!["fees"]) as? Int)!,
                                    deduction: ((order["amount"]!["deduction"]) as? Int)!,
                                    otherReceivers: ((order["amount"]!["otherReceivers"]) as? Int)!))
                            
                    }
                }

                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()

                    })
                }catch{
                    print(error)
                }
            }

        })
        
        dispatch_async(dispatch_queue_create("get_result", nil)) { 
            task.resume()
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    
        
}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //PORTRAIT
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    


}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaOrders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? ResultTableViewCell{
            let order = self.listaOrders[indexPath.row]
            
            //method img
            var imgMethod:UIImage
            if order.method == "BOLETO"{
                imgMethod = UIImage(named: "boleto")!
            }
            else{
                imgMethod = UIImage(named: "cartao")!
            }
            
            
            
            cell.valorLabel.text = ("\(order.currency) \(order.total)")
            cell.ownIdLabel.text = (order.id)
            cell.emailLabel.text = order.email
            cell.button.setTitle(order.status, forState: UIControlState.Normal)
            cell.dateLabel.text  = order.createdAt
            cell.methoImg.image  = imgMethod
            
            // cores do status

            if cell.button.currentTitle == "PAID"{
                cell.button.setTitleColor(UIColor(red: 034/255, green: 139/255, blue: 034/255, alpha: 1.0), forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.clearColor()
                cell.button.layer.cornerRadius = 5
                cell.button.layer.borderWidth = 1
                cell.button.layer.borderColor = UIColor(red: 034/255, green: 139/255, blue: 034/255, alpha: 1.0).CGColor
            }
            if  cell.button.currentTitle == "WAITING"{
                cell.button.setTitleColor(UIColor(red: 255/255, green: 215/255, blue: 000/255, alpha: 1.0), forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.clearColor()
                cell.button.layer.cornerRadius = 5
                cell.button.layer.borderWidth = 1
                cell.button.layer.borderColor = UIColor(red: 255/255, green: 215/255, blue: 000/255, alpha: 1.0).CGColor
            }
            if  cell.button.currentTitle == "REVERTED" || cell.button.currentTitle == "NOT_PAID"  {
                cell.button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                cell.button.backgroundColor = UIColor.clearColor()
                cell.button.layer.cornerRadius = 5
                cell.button.layer.borderWidth = 1
                cell.button.layer.borderColor = UIColor.redColor().CGColor
            }
            
            
            return cell
        }
        else {
            print("Problemas nas celulas")
        }
        return UITableViewCell()
        
    }
}