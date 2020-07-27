//
//  ViewController.swift
//  URLImagesPreview
//
//  Created by ABHI MAC on 28/02/20.
//  Copyright © 2020 ABHI MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    
   
    //Converted Data From URL
    var convertedData:[MovieDetails]!
    
    //Request to the URL
    var URLReq:URLRequest!
    
    //Task
    var dataTask:URLSessionTask!
    
    //Scroll View For Poster
    var ScollForPoster:UIScrollView!
    
    //Scroll view For Story
    var ScollForStory:UIScrollView!
    
    //Poster On Button
    var posterBtn:UIButton!
    
    var i:Int!
    
    //Page Control
    var page:UIPageControl!
    
    //Label For Title
    var titleLabel:UILabel!
    
    //Title From Server
    var titleLblFromServer:UILabel!
    
    //Title For Actor
    var actor:UILabel!
    
    //Label For Actor Name From Server
    var actorLabel:UILabel!
    
    //Director Label
    var directorLabel:UILabel!
    
    // Label for Director From Server
    var direcLblFromServer:UILabel!
    
    // Scroll View Story
    var storyScroll:UIScrollView!
    
    //Label For Story
    var story:UILabel!
    
    //Label For Story From Server
    var storyLabel:UILabel!
   
    var timer = Timer()
    var counter = 0
    
   
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Backgraound Color Of Main View Conatroller
        view.backgroundColor=#colorLiteral(red: 0.9399586916, green: 0.8130092025, blue: 0.723115623, alpha: 1)
        
        
        //Calling Function For Get Movie Data From Server
        getMovieData()
        
        //Calling Function For Crate UI For This Project
        createUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //Create Custom Button and Display Poster on Button
    func createButton(movieDetails:[MovieDetails])
    {
        //Declare The Value Of X axis
        var x=10
        
        //Open Loop For Creating Button Depend Upon We get Value From Server
        for i in 0..<movieDetails.count
        {
           
            //Type Of Button = Custom
            posterBtn=UIButton(type: UIButton.ButtonType.custom)
            //Frame Of Button
            posterBtn.frame=CGRect(x: x, y: 10, width: 375, height: 280)
            //Tag Of Button
            posterBtn.tag = i
            //Make At Visible
            ScollForPoster.addSubview(posterBtn)
            
        
            var image:String="https://www.brninfotech.com/tws/" + "\(movieDetails[i].posters![0])"
          
            //Poster
            posterBtn.setImageFromURL(imgURL: image)
            
                //Add Target On Button tapped
            posterBtn.addTarget(self, action: #selector(onBtnTapped(tappedButton:)), for: UIControl.Event.touchUpInside)
            
            //Now The Value Of X Is 395
            x+=395
            
        }
        //Extend The Width Of Scroll view Depend Upon How Much Movie Detail Will Come from Server
        ScollForPoster.contentSize=CGSize(width: x*movieDetails.count, height: 300)
        
        //Frame Of Page Control
        page=UIPageControl(frame: CGRect(x: 50, y: 340, width: 300, height: 11))
        //No.Of Pages Depend Upon The Data
        page.numberOfPages=convertedData.count
        //Indicator Tint Color of Page
        page.pageIndicatorTintColor = .black
        //Current page Tint Color
        page.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
//        page.tag = i
        //Make At Visible
        view.addSubview(page)
        //No.Of Pages
        page.currentPage = 0
        ScollForPoster.delegate = self
        page.addTarget(self, action: #selector(onpageChange), for: .valueChanged)
    
    }
    
    
    
    //Add Target For ScrollView for Change Scroll The Pages
    @objc func scrollViewDidScroll(_ ScollForPoster: UIScrollView) {
          do {
              let pageNumber = self.ScollForPoster.contentOffset.x/ScollForPoster.frame.width
              self.page.currentPage = Int(pageNumber)
          }
      }

    
    //Add Target For Page Control
    @objc func onpageChange(){
           (page.currentPage)*Int(ScollForPoster.frame.width)
            ScollForPoster.scrollRectToVisible(CGRect(x: 20, y: 390, width: Int(ScollForPoster.frame.width), height: Int(ScollForPoster.frame.height)), animated: true)
           
        }
    
    
    //Add Target For On Tapped On Button
    @objc func onBtnTapped(tappedButton:UIButton)
    {
        
        print(convertedData[tappedButton.tag])
        
        //Display The Title In Label
        self.titleLblFromServer.text = convertedData[tappedButton.tag].title

        //Display The Actor Name In Label
        var actorsStr = ""
        
        //Open Loop For Get The Actor Deatil
        for i in 0..<convertedData[tappedButton.tag].actors!.count
        
        {
            actorsStr += convertedData[tappedButton.tag].actors![i]+","
        }
        
        actor.text = actorsStr
        
        //Display The Director Name In Label
        self.direcLblFromServer.text = convertedData[tappedButton.tag].director

        //Display The Story Of Movie In Scroll View
        self.storyLabel.text = convertedData[tappedButton.tag].story

    }
    
    
    //Create A function For Get Movie Detail
    func getMovieData()
    {
        
        //Request To The Server And get data
        URLReq=URLRequest(url: URL(string: "https://www.brninfotech.com/tws/MovieDetails2.php?mediaType=movies")!)
        //Http Method either Post Or Get
        URLReq.httpMethod="GET"
        
        //Convert Json to Swift
        dataTask=URLSession.shared.dataTask(with: URLReq, completionHandler: { (data, resp, err) in
            
            //If Error Is Not Equal to nil Value
            if(err != nil)
            {
               
                //Print The Reason Of Getting Error
                print(err?.localizedDescription)
               
                
            }
            else
            {
                do
                    {
                     //Convert JSON to swift
                    self.convertedData=try JSONDecoder().decode([MovieDetails].self, from: data!)
                                   
                                   print(self.convertedData)
                                   
                        //When We Get Data From Server And We Want To display In Label
                        DispatchQueue.main.async
                            {
                              self.createButton(movieDetails: self.convertedData)
                            }
                                   
                            }
                               catch
                               {
                                   print(err?.localizedDescription)
                               }
                               
              }
    
        })
        //Resume The Data Task
        dataTask.resume()
        
        
    }
    
    
    //Create UI For Display All Data Came From Server
    func createUI()
    {
        
        //Create Scroll view Fpr Poster
        //Frame Of Scroll View For Poster
        ScollForPoster=UIScrollView(frame: CGRect(x: 10, y: 40, width: 395, height: 300))
        //Background Color Of Scroll View of Poster
        ScollForPoster.backgroundColor=#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        //Paging Enable
        ScollForPoster.isPagingEnabled = true
        //Show HoriZontal Indicator
        ScollForPoster.showsHorizontalScrollIndicator = false
        //Make At Visible
        view.addSubview(ScollForPoster)
        

        //Set The Frame Of Title Label
        titleLabel=UILabel(frame: CGRect(x: 40, y: 340, width: 200, height: 70))
        //Title Name
        titleLabel.text = "Movie Title = "
        //Title Text color
        titleLabel.textColor = UIColor.blue
        //Title font name Of Size
        titleLabel.font = UIFont(name:"Cochin", size: 30.0)
        //No. of Lines
        titleLabel.numberOfLines=0
        //Make At Visible
        view.addSubview(titleLabel)
        
        
        //Set The Frame Of Label
        titleLblFromServer=UILabel(frame: CGRect(x: 210, y: 343, width: 395, height: 70))
        //No. Of Lines
        titleLblFromServer.numberOfLines=0
        //Title font name Of Size
        titleLblFromServer.font = UIFont(name:"Papyrus", size: 30.0)
        //Make It Visible
        view.addSubview(titleLblFromServer)


        //Set The Frame Of Actor Label
        actor=UILabel(frame: CGRect(x: 40, y: 430, width: 380, height: 70))
        //Label font name Of Size
        actor.font = UIFont(name:"Cochin", size: 20.0)
        actor.numberOfLines=0
        //Make It Visible
        view.addSubview(actor)


        //Set The Frame Of Actor Label
        actorLabel=UILabel(frame: CGRect(x: 150, y: 380, width: 395, height: 70))
        actorLabel.numberOfLines = 0
        //Label Text
        actorLabel.text = " -- Actor -- "
        //Text Color
        actorLabel.textColor = UIColor.purple
        //Label font name Of Size
        actorLabel.font = UIFont(name:"Cochin", size: 25.0)
        //Make It Visible
        view.addSubview(actorLabel)


        //Set The Frame Of Director Label
        directorLabel=UILabel(frame: CGRect(x: 120, y: 480, width: 395, height: 70))
        directorLabel.numberOfLines=0
        //Label Text
        directorLabel.text = " -- Director -- "
        //Label font name Of Size
        directorLabel.font = UIFont(name:"Cochin", size: 25.0)
        //Text Color
        directorLabel.textColor = UIColor.systemPink
        //Make It Visible
        view.addSubview(directorLabel)

         //Set The Frame Of Director Label Get Data From Server
        direcLblFromServer=UILabel(frame: CGRect(x: 110, y: 510, width: 395, height: 70))
        direcLblFromServer.numberOfLines=0
        //Label font name Of Size
        direcLblFromServer.font = UIFont(name:"Menlo-Italic", size: 20.0)
        //Make It Visible
        view.addSubview(direcLblFromServer)

        // Set Frame For Story Label
        story=UILabel(frame: CGRect(x: 140, y: 560, width: 200, height: 50))
        story.numberOfLines=0
        story.textColor = UIColor.magenta
        story.text = " -- Story -- "
        story.font = UIFont(name:"Cochin", size: 30.0)
        //Make It Visible
        view.addSubview(story)

        
        
        //Set The Frame Of Scroll View For Story
        storyScroll=UIScrollView(frame: CGRect(x: 10, y: 605, width: 395, height: 300))
        storyScroll.contentSize.height = CGFloat(Int.max)
        storyScroll.backgroundColor=#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        //Make It Visible
        view.addSubview(storyScroll)

        
         //Set The Frame Of Label for Story
        storyLabel=UILabel(frame: CGRect(x: 10, y: 0, width: 370, height: 500))
        storyLabel.textColor = UIColor.red
        storyLabel.numberOfLines=0
        storyLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
        //Make It Visible
        storyScroll.addSubview(storyLabel)
        
    }


}

//Using Extention For Add Some Funtion In Existing/Locked Classes
extension UIButton
{
    //Add Function UIButton Class
    func setImageFromURL(imgURL:String)
    {
        
        
        // Set PlaceHolder for Image
        self.setImage(UIImage(named: "Place"), for: UIControl.State.normal)
        
        //Remove Spaces From the URL Of Images
        var correctURL=imgURL.replacingOccurrences(of: " ", with: "%20")
        
        //Get Data From Server
        var dataTask=URLSession.shared.dataTask(with: URL(string: correctURL)!, completionHandler: { (data, resp, err) in
            
            //If Error is Not Equal to nil
            if(err != nil)
            {
               //Print The Main Error Reason
                print(err?.localizedDescription)
                
                
            }
            else
            {
                do
                    {
                        //When We Get Data From Server And We Want To display In Label
                        DispatchQueue.main.async
                            {
                                self.setImage(UIImage(data: data!), for: UIControl.State.normal)
                            }
                                   
                               }
                               catch
                               {
                                   print(err?.localizedDescription)
                               }

            }
            
        })
        //Resume Data Task
        dataTask.resume()
        
    }
}



