//
//  LoginViewController.swift
//  uService
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL: URL = URL(string: "https://0944tu0fdb.execute-api.us-west-2.amazonaws.com/prod/jobs")!
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            //do stuff with response, data, and error here
            guard error == nil else {
                print ("error calling GET")
                print (error)
                return
            }
            guard let responseData = data else {
                print ("Error: did not receive data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! NSDictionary
                print (json)
                print ("done")
            }
            catch {
                print ("Error trying to convert data to json")
                return
            }
            
        })
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
/* 
 The icons we use for the tab bar come from a website that asks us to link to each icon in our About page. The links are as such:
 search: https://icons8.com/web-app/5269/search-property
 home: https://icons8.com/web-app/73/home
 post: https://icons8.com/web-app/7989/currency#filled
 settings: https://icons8.com/web-app/14099/settings
*/
}
