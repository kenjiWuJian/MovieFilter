//
//  ViewController.swift
//  MovieFilter
//
//  Created by JoannaWQ on 21/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MovieManagerDelegate,UITextFieldDelegate {

//    @IBOutlet weak var resultBtn: UIButton!
    
   // @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextField: UITextField!
    var movieManager = MovieManager()
    var result1:[Result] = []
    var result2:[Result] = []
    //var totalPages:Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    
    
    @IBAction func resultBtn(_ sender: UIButton) {
        print("Hello\(test(5))")
        for index in 1...2{
            movieManager.performRequest(urlString: movieManager.fetchMovie(page: index))
        }
        
        //movieManager.performRequest(urlString: movieManager.fetchMovie2017S1(page: 2))
        //movieManager.performRequest(urlString: movieManager.fetchMovie2017S1(page: 3))
        //print();
    }
    func  didUpdateMovieData(movieData:MovieData){
        //var result:[Result] = []
        
        result2 = movieManager.sortPage(movieData: movieData)
        if result1.count == 0{
            result1 = result2
        }else{
            result1 = movieManager.merge2Result(movieData1: result1, movieData2:result2)
        }
        let page = movieData.page
        print(page)
        //print final result
        if page == 100{
        for index in 0...result1.count-1{
            print(result1[index].vote_average)
            print(result1[index].title)
        }
        }
 
        
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
    
}

