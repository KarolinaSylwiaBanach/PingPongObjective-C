//
//  ResultModel.h
//  PingPongObjective-C
//
//  Created by Karolina Banach on 11/05/2020.
//  Copyright © 2020 Karolina Banach. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ResultModelDelegate
- (void)itemsDownloaded;
@end

@interface ResultModel : NSObject

//protocol ResultModelDelegate {
//    func itemsDownloaded(result:[Result])
//
//}
//class ResultModel:NSObject{
//    var URLRESULT = "http://karolinabanachios.cba.pl/getResult.php"
//    var delegate : ResultModelDelegate?
//    var namePlayer = ""
//
//    init(urlPlayer:Bool, namePlayer:String) {
//        if(urlPlayer){
//            self.URLRESULT = "http://karolinabanachios.cba.pl/getPlayerResult.php"
//        }else{
//            self.URLRESULT = "http://karolinabanachios.cba.pl/getResult.php"
//        }
//        self.namePlayer = namePlayer
//    }
//
//    func getItems(){
//        var resultArray = [Result]()
//        let parameters: Parameters=[
//            "name" : namePlayer
//        ]
//
//        //Sending http post request
//        Alamofire.request(self.URLRESULT, method: .post, parameters: parameters).responseJSON
//        {
//            response in
//
//            //getting the json value from the server
//            if let result = response.result.value {
//                guard let jsonArray = result as? [[String: Any]] else {
//                      return
//                }
//                for dic in jsonArray{
//                    resultArray.append(Result(dic))
//                }
//                self.delegate?.itemsDownloaded(result: resultArray)
//            }
//
//       }
//
//    }

@end

NS_ASSUME_NONNULL_END
