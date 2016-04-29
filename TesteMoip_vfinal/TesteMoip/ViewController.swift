import UIKit


class ViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    //IBAction
    
    @IBAction func loginBtn(sender: AnyObject) {
        self.login()
    }
    
    func login(){
        
        //url da chamada
        
        let url = NSURL(string: "https://sandbox.moip.com.br/oauth/accesstoken")
        
        //request
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let user = self.emailTextField.text!
        let pwd  = self.senhaTextField.text!
        
        
        
        let jsonUpdate = [
            "appId": "APP-YYOOK4LMHJS8",
            "appSecret": "iwnd4dmi4vni6azf6lzuxmhe0qtq8ut",
            "grantType": "password",
            "username": "\(user)",
            "password": "\(pwd)",
            ]
        
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonUpdate, options: NSJSONWritingOptions.PrettyPrinted)
        
        //configurar o Header no http
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        
        
        //sessao da url ja criada
        let session = NSURLSession.sharedSession()
       
        let task = session.dataTaskWithRequest(request) { (data:NSData?, respose:NSURLResponse?, error:NSError?) in
            
            print(data)
            do{
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                print(json)
                if let token = json["access_token"] as? NSString{
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(token, forKeyPath: "token")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("ShowResult", sender: self)
                    })
                }
                if let loginError = json["errors"] as? NSArray{
                    
                    if let dicError = loginError.firstObject as? NSDictionary {
                    
                        print(dicError["code"] )
                        print(dicError["description"] )
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showMessage("Opps \(dicError["description"]!)")
                        })
                        
                    }
                    
                }
                
            }catch{
                
                print(error)
            }
            
            
            
        }
        task.resume()
    
    }
    
    func showMessage(message:String){
        
       let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.valueForKey("token") as? String{
            
            dispatch_async(dispatch_get_main_queue(), {
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

