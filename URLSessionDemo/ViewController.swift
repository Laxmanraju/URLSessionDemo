//Kilo loco
//  ViewController.swift
//  URLSessionDemo
//
//  Created by l on 7/13/17.
//  Copyright © 2017 l. All rights reserved.
//
// Imagur API
// Authorization: Client-ID YOUR_CLIENT_ID
// Client ID: 235722d6b252d4b
// Client secret



import UIKit
typealias Parameters = [String: String]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func GetRequest(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        var request = URLRequest(url: url)
        let boundary = generateBoundary()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataBody =  createDataBody(withParameters: nil, media: nil, boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let response =  response{
                print("response = \(response)")
            }
            
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JsonData = \(json)")
                }catch{
                    print(error)
                }
            }
            
        }.resume()
    
    }

    @IBAction func postRequest(_ sender: Any) {
        
        let parameters = ["name":"MyTestFile1244321",
                          "description":"My Tutorial For multipart form data uploads"]
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testImage"), forKey: "image")else{return}
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID 235722d6b252d4b", forHTTPHeaderField: "Authorization")
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
        let dataBody =  createDataBody(withParameters: parameters, media: [mediaImage], boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let response =  response{
                print("response = \(response)")
            }
            
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JsonData = \(json)")
                }catch{
                    print(error)
                }
            }
            
            }.resume()
    }
//    @IBAction func postRequest(_ sender: Any) {
//        
//        let parameters = ["name": "MyTestFile123321",
//                          "description": "My tutorial test file for MPFD uploads"]
//        
//        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testImage"), forKey: "image") else { return }
//        
//        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        let boundary = generateBoundary()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
//        
//        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
//        request.httpBody = dataBody
//        
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//            
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print(error)
//                }
//            }
//            }.resume()
//    }
    
    func generateBoundary()->String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func  createDataBody(withParameters params:Parameters?, media:[Media]?, boundary:String) -> Data {
        let lineBreak = "\r\n"
        var body  = Data()
        if let parameters = params{
            for(key, value) in parameters{
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for photo in media{
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("COntent-Type: \(photo.mime + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    

}

    
extension Data{
    mutating func append(_ string: String){
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
    
}

