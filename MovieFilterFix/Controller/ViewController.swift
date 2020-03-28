//
//  ViewController.swift
//  MovieFilter
//
//  Created by Wu Jian on 21/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MovieManagerDelegate,UITextFieldDelegate {
        var movieManager = MovieManager()
       var result1:[Result] = []
       //var result2:[Result] = []
       var totalPages = 0
    let myDefault = UserDefaults.standard
    static var apikey:String = ""
    static let myApiKey = "myApikey"
    //delete function, will be called after url request
    func didUpdateMovieData(movieData: MovieData) {
        result1.removeAll()
        //2 buffers are designed to handle multiple requests automatically, and currently I don't have a method to handle it
        //result2.removeAll()
        result1 = movieManager.sortPage(movieData: movieData)
        /*
            if result1.count == 0{
                result1 = result2
            }else{
                result1 = movieManager.merge2Result(movieData1: result1, movieData2:result2)
            }
            */
            
            for index in 0...result1.count-1{
                print(result1[index].vote_average)
                print(result1[index].title)
            }
        
        /* this will crash system, no solution yet, call another thread to try?
         Here I assume you don't need me to request multiple pages
        if (movieData.page < movieData.total_pages) && (movieData.total_pages != 500)
        {
           movieManager.performRequest(urlString:movieManager.fetchMovie(userInput:searchTextField.text!,page:(movieData.page+1)))
        }
        */
        totalPages = movieData.total_pages
        
       // }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        idTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
        idTextField.text = ""
    }
    
    
    //@IBOutlet weak var myTableView: UITableView!
    
    //@IBOutlet weak var myTableView: UITableView!
    
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func resultBtn(_ sender: UIButton) {
        //if user input a wrong key word, the default query will be called, and result would be 500 pages and 10000 results, it is not what the user want, so don't do the query
        if totalPages == 500
        {
            resultTextView.text = ""
            resultTextView.text = "Please input a correct keyword"
            //here in case user directly click show result button
        }else if result1.count == 0{
            resultTextView.text = ""
            resultTextView.text = "Please set app id and type search keyword first"
        }else{
            resultTextView.text = ""
            for index in 0...(result1.count-1){
                resultTextView.text += "\(index+1) \(result1[index].title) \(result1[index].vote_average) \(result1[index].release_date)"
                resultTextView.text += "\n"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieManager.delegate = self
        searchTextField.delegate = self
        loadAPIkey()
        movieManager.getAppId(appId:ViewController.apikey)
        //idTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if searchTextField.text != "" {
            movieManager.performRequest(urlString:movieManager.fetchMovie(userInput:searchTextField.text!,page:1))
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        }
    }
    
    @IBAction func Enter(_ sender: UIButton) {
        //print(idTextField.text!)
        saveAPIkey(key: idTextField.text!)
        //print("save key \()")
        movieManager.getAppId(appId:idTextField.text!)
        //loadAPIkey()
        idTextField.endEditing(true)
    }
    
    func saveAPIkey(key:String){
        myDefault.set(key,forKey:ViewController.myApiKey)
        print("save key\(key)")
    }
    
    func loadAPIkey(){
        ViewController.apikey = myDefault.string(forKey: ViewController.myApiKey)!
        
        print("load api key\(ViewController.apikey)")
        
    }
}

