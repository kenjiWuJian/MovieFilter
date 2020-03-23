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
        totalPages = movieData.total_pages
        result2.removeAll()
        result2 = movieManager.sortPage(movieData: movieData)
        print(result2.count)
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

       // }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
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
    }
    
    
    //@IBOutlet weak var myTableView: UITableView!
    
    //@IBOutlet weak var myTableView: UITableView!
    
   
    @IBOutlet weak var searchTextField: UITextField!
   
    //@IBOutlet weak var resultTable: UITableView!
    //var totalPages:Int
    //@IBOutlet weak var label0: UILabel!
  
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
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        movieManager.performRequest(urlString:movieManager.fetchMovie(userInput:searchTextField.text!,page:1))
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    
    
/*
    @IBAction func resultBtn(_ sender: UIButton) {
        print("Hello\(test(5))")
        for index in 1...2{
            movieManager.performRequest(urlString: movieManager.fetchMovie(page: index))
        }
   */
        //movieManager.performRequest(urlString: movieManager.fetchMovie2017S1(page: 2))
        //movieManager.performRequest(urlString: movieManager.fetchMovie2017S1(page: 3))
        //print();
  //  }
/*
    func didUpdateMovieData(movieData: MovieData) {
        
}
    
    func didFailWithError(error: Error) {
        
    }
 */
  

    
}

