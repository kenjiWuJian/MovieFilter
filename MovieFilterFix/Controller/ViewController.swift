//
//  ViewController.swift
//  MovieFilter
//
//  Created by JoannaWQ on 21/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MovieManagerDelegate,UITextFieldDelegate {
        var movieManager = MovieManager()
       var result1:[Result] = []
       var result2:[Result] = []
       var totalPages = 0
       // var test:[String] = ["a","de","t","s","w","a","de","t","s","w"]
    func didUpdateMovieData(movieData: MovieData) {
        
        result2.removeAll()
        result2 = movieManager.sortPage(movieData: movieData)
            if result1.count == 0{
                result1 = result2
            }else{
                result1 = movieManager.merge2Result(movieData1: result1, movieData2:result2)
            }
            
            //let page = movieData.page
            //print(page)
            //print final result
            //if page == 100{
            for index in 0...result1.count-1{
                print(result1[index].vote_average)
                print(result1[index].title)
            }
        
        /* this will crash system, no solution yet, call another thread to try?
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
    
    @IBAction func idTextField(_ sender: UITextField) {
    }

  
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func resultBtn(_ sender: UIButton) {
        if totalPages == 500
        {
            resultTextView.text = ""
            resultTextView.text = "Please input a correct keyword"
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
        //idTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        movieManager.performRequest(urlString:movieManager.fetchMovie(userInput:searchTextField.text!,page:1))
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    @IBAction func Enter(_ sender: UIButton) {
        print(idTextField.text!)
        movieManager.getAppId(appId:idTextField.text!)
        idTextField.endEditing(true)
    }
}

