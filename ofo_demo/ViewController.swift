//
//  ViewController.swift
//  ofo_demo
//
//  Created by Risen on 2017/5/25.
//  Copyright © 2017年 Risen. All rights reserved.
//

import UIKit
import SWRevealViewController
import FTIndicator

class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {
    var mapView :MAMapView!
    var search: AMapSearchAPI!
    var pin : MyPinAnnotation!
    var pinView : MAAnnotationView!
    var nearBySearch = true
    var start , end :CLLocationCoordinate2D!
    var  walkManager:AMapNaviWalkManager!
    
    
    @IBAction func locationBtnTap(_ sender: Any) {
        nearBySearch = true
        searchBikenearby()
    }
    //大头针动画
    func pinAnimation(){
     //醉落效果y增加若干唯一
        let endFrame = pinView.frame
        
    pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
        self.pinView.frame = endFrame
    }, completion: nil)
    
    
    }
    //添加大头针视图
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        for aView in aViews
        {
            guard aView.annotation is MAPinAnnotationView else {
                continue
            }
            aView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: { 
                aView.transform = .identity
            }, completion: nil)
            
        }
        
    }
    //地图didMove(用户移动地图的交互)
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            pin.isLockedToScreen = true
            pinAnimation()
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    //地图初始完成后
    func mapInitComplete(_ mapView: MAMapView!) {
     
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate
        pin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        pin.isLockedToScreen = true
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        searchBikenearby()
    }
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //用户自己定位的位置不需要自定义
        if annotation is MAUserLocation {
            return nil
        }
        let reuseid  =  "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
        }
        
        if annotation  is  MyPinAnnotation {
            let  reuseid = "anchor"
            var av  =  mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            if av == nil {
                av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            av?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            av?.canShowCallout  = false
            pinView = av
            return av
            
            
        }
        if annotation.title == "正常可用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }else
        {
         annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        annotationView?.canShowCallout = true
        annotationView?.animatesDrop = true
      return annotationView
    }
 
//MARK:-- MapView Delegate
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("点击了")
        start = pin.coordinate
        end  = view.annotation.coordinate
        let startPoint  = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint  = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
        
        
        
        
    }
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline
        {
             pin.isLockedToScreen = false
            mapView.visibleMapRect = overlay.boundingMapRect
            let render  =  MAPolylineRenderer(overlay: overlay)
            render?.lineWidth = 8.0
            render?.strokeColor = UIColor.blue
           return  render
            
        }
        return nil
    }
    
    
    //搜索周边的小黄车请求
    func searchBikenearby()  {
        
        searchCustomLocation(mapView.userLocation.coordinate)
        
    }
    func searchCustomLocation(_ center :CLLocationCoordinate2D)  {
        let request =  AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500
        request.requireExtension = true
        search.aMapPOIAroundSearch(request)
    }
    //搜索周边完成后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
//        if response.count == 0 {
//            print("周边没有小黄车")
//        }
        guard response.count>0 else {
         print("周边没有小黄车")
         return
        }
//        for poi  in response.pois {
//           // dump(poi)
//           print(poi.name)
//        }
        var annotations : [MAPointAnnotation] = []
        annotations = response.pois.map{
          let annotation = MAPointAnnotation ()
          annotation.coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees($0.location.latitude), longitude:CLLocationDegrees($0.location.longitude))
         if $0.distance < 400
         {
            annotation.title = "红包区域内开锁任意小黄车"
            annotation.subtitle = "骑行10分钟内可以获得现金红包"
            }else
         {
            annotation.title = "正常可用"
            
            }
          return annotation
        }
      mapView.addAnnotations(annotations)
        if nearBySearch  {
           mapView.showAnnotations(annotations, animated: true)
           nearBySearch = !nearBySearch
        }
     
        
        
    }
    @IBOutlet weak var panelView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.zoomLevel = 17
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        search = AMapSearchAPI()
        search.delegate = self
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        
        
        view.bringSubview(toFront: panelView)
        self.navigationItem.titleView=UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        
        self.navigationItem.leftBarButtonItem?.image=#imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image=#imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.backBarButtonItem=UIBarButtonItem(title:"", style:.plain, target: nil, action: nil)
        if let revealVc = revealViewController() {
             revealVc.rearViewRevealWidth = 280
            navigationItem.leftBarButtonItem?.target = revealVc
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealVc.panGestureRecognizer())
        }
        
        for i in 0 ..< 5
        { //从0开始到小于5
                         print("i=\(i)")
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK --walkManager Delegate
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
       print("步行路线成功")
      mapView.removeOverlays(mapView.overlays)
        var coordinates = walkManager.naviRoute!.routeCoordinates!.map{
         
          return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        let polyline =  MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
        
        
        //提示距离和用时
        
        let warkMinute = walkManager.naviRoute!.routeTime / 60
        
        var timeDesc = "一分钟内"
        
        if warkMinute > 0 {
         
         timeDesc = warkMinute.description + "分钟"
        }
        
        let  hintTitle =  "步行" + timeDesc
        let  hintSubTitle =  "距离" + walkManager.naviRoute!.routeLength.description + "米"
//        let ac  =  UIAlertController(title: hintTitle, message: hintSubTitle, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        ac.addAction(action)
//        self.present(ac, animated: true, completion: nil)
//        
       FTIndicator .setIndicatorStyle(.dark)
       FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubTitle)
        
        
        
        
        
        
        
    }
    func walkManager(_ walkManager: AMapNaviWalkManager, error: Error) {
        print(error)
    }
    
    

}

