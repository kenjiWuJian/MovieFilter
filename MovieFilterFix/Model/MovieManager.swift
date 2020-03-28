//
//  MovieManager.swift
//  MovieFilter
//
//  Created by Wu Jian on 22/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

import Foundation
protocol MovieManagerDelegate{
    func didUpdateMovieData(movieData:MovieData)
    func didFailWithError(error:Error)
}
struct MovieManager {
    var movieURL = ""
    var delegate:MovieManagerDelegate?
    func fetchMovie(userInput:String,page:Int)->String
    {
        let urlStr = movieURL + userInput + "&page=" + String(page)
        //print(urlStr)
        return urlStr
    }
    
    
    
    func performRequest(urlString:String){
            //1 Create a url
        if let url = URL(string: urlString){
            //2 Create a URLSession
            let session = URLSession(configuration: .default)
            //3 Give the session a task
            let task = session.dataTask(with:url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data{
                    if let movieData = self.parseJSON(movieData: safeData){
                        self.delegate?.didUpdateMovieData(movieData:movieData)
                    }
                }
            }
            
            //4 Start the task
            task.resume()
            
        }
       
    }
    func parseJSON(movieData:Data)->MovieData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            //print(decodedData)
            return decodedData
            //print(decodedData.results[0].vote_average)
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    //to sort 1 page, keep the highest top 10 rating and delete others
    func sortPage(movieData:MovieData)->[Result]
    {
        let size = movieData.results.count
        var md = movieData
        var vote_average:[Int32] = []
        for index in 0...(size-1){
            //because I can't find a way to convert array of double element to c pointer, so convert to int instead, and vote_average format is x.x or x, so it should be fine :(
            //directly dump 0 vote
            if Int(movieData.results[index].vote_average) != 0{
                vote_average.append(Int32(movieData.results[index].vote_average*10))
            }
        }
        print(vote_average.count)
        let pointer: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(&vote_average)
        //let array = Array(UnsafeBufferPointer(start: pointer, count: size))
        //var cargs = vote_average.map { $0.flatMap { UnsafePointer<Int32>(strdup($0)) } }
        quickSort(pointer,0,Int32(vote_average.count-1))
        var vote_averageDouble:[Double] = []
        for index in 0...(vote_average.count-1){
            vote_averageDouble.append(Double(vote_average[index])/10)
        }
        //if result >=10, keep 10 and delete the left, else keep all
        var result:[Result] = []
        print(vote_average.count)
        if vote_average.count >= 10{
            for index in 0...9{
                for index2 in 0...(vote_average.count-1){
                    if md.results[index2].vote_average == vote_averageDouble[index]{
                        result.append(movieData.results[index2])
                       
                        //here do a trick to modify vote_average to a impossible value
                        md.results[index2].vote_average = 11
                        break
                    }
                }
            }
        }else{
            for index in 0...(vote_average.count-1){
                for index2 in 0...(size-1){
                    if md.results[index2].vote_average == vote_averageDouble[index]{
                        result.append(movieData.results[index2])
                        md.results[index2].vote_average = 11
                        break
                    }
                }
            }
        }
        return result
    }
    //to merge 2 result, always keep the top 10
    //test with several pages result are ok. But I can't think a good way to trigger multiple request. Maybe your reqirement doesn't need to request muliple pages? Then this function is useless
    func merge2Result(movieData1:[Result],movieData2:[Result])->[Result]
    {
        let size1 = movieData1.count
        let size2 = movieData2.count
        var mvResult = movieData1+movieData2
        
        var vote_average1:[Int32] = []
        var vote_average2:[Int32] = []
        var vote_average:[Int32] = []
        for index in 0...(size1-1){
            //because I can't find a way to convert array of double element to c pointer, so convert to int instead, and vote_average format is x.x or x, so it should be fine :(
            vote_average1.append(Int32(movieData1[index].vote_average*10))
            //easy way to give vote_average same length of vote_average1+vote_average2, will have order after run the Merge
            vote_average.append(Int32(movieData1[index].vote_average*10))
        }
        for index in 0...(size2-1){
            //because I can't find a way to convert array of double element to c pointer, so convert to int instead, and vote_average format is x.x or x, so it should be fine :(
            vote_average2.append(Int32(movieData2[index].vote_average*10))
            vote_average.append(Int32(movieData2[index].vote_average*10))
        }
        let pointer: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(&vote_average)
        //let pointer1: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(&vote_average1)
        //let pointer2: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(&vote_average2)
        //let pointer3: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(&vote_average)
        /*
        for index in 0...(vote_average.count-1){
            print(vote_average[index])
        }*/
        //Merge(pointer1,Int32(size1),pointer2,Int32(size2), pointer3)
        quickSort(pointer,0,Int32(vote_average.count-1))
        
        var vote_averageDouble:[Double] = []
        for index in 0...(vote_average.count-1){
            vote_averageDouble.append(Double(vote_average[index])/10)
        }
        //if result >=10, keep 10 and delete the left, else keep all
        var result:[Result] = []
        if vote_average.count >= 10{
            for index in 0...9{
                for index2 in 0...(vote_average.count-1){
                    if mvResult[index2].vote_average == vote_averageDouble[index]{
                        result.append(mvResult[index2])
                        //here do a trick to modify vote_average to a impossible value
                        mvResult[index2].vote_average = 11
                        break
                    }
                }
            }
        }else{
            for index in 0...(vote_average.count-1){
                for index2 in 0...(size1+size2-1){
                    if mvResult[index2].vote_average == vote_averageDouble[index]{
                        result.append(mvResult[index2])
                        mvResult[index2].vote_average = 11
                        break
                    }
                }
            }
        }
        return result
        
    }
    
    mutating func getAppId(appId:String)
    {
          movieURL = "https://api.themoviedb.org/3/discover/movie?api_key="+appId
          movieURL += "&language=en-US&primary_release_date.gte=2017-01-01&primary_release_date.lte=2018-12-31&"
        print(movieURL)
    }
}

struct MovieData:Decodable{
    let page:Int
    let total_results:Int
    let total_pages:Int
    var results:[Result]
}

struct Result:Decodable{
    let popularity:Double
    let id:Int
    let video:Bool
    let vote_count:Int
    var vote_average:Double
    let title:String
    let release_date:String
    let original_language:String?
    let original_title:String?
    let genre_ids:[Int]
    let backdrop_path:String?
    let adult:Bool
    let overview:String?
    let poster_path:String?
}
