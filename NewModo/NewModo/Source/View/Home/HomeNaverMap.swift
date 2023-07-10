//
//  HomeNaverMap.swift
//  Modo
//
//  Created by MacBook on 2023/05/14.
//

import SwiftUI
import NMapsMap

//typealias LatLng = (Double, Double)

struct HomeNaverMap: UIViewRepresentable {
    //@Binding var cameraPosition: LatLng
    
    func makeCoordinator() -> HomeCoordinator {
        HomeCoordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

final class HomeCoordinator: NSObject, ObservableObject,NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    static var shared = HomeCoordinator()
    
    let view = NMFNaverMapView(frame: .zero)
    
    var currentAddress: String = ""
    var markers: [NMFMarker] = []
    var selectedMarker : NMFMarker? = nil
    var locationManager: CLLocationManager?
    var reverseGeocodeVM: ReverseGeocodeViewModel = ReverseGeocodeViewModel()
    var bookVM: BookViewModel = BookViewModel()
    var users: [User] = User.getDummy()
    var userBooks:[String:[Book]] = [:]
    
    
    @Published var coord: (Double, Double) = (0.0, 0.0) //카메라 위치
    @Published var userLocation: (Double, Double) = (0.0, 0.0)// 유저 위치
    @Published var currentUserId: String = ""
    @Published var isMarkerTapped: Bool = false
    
    override init() {
        super.init()
        
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        // MARK: - 줌 레벨 제한
        view.mapView.zoomLevel = 15 // 기본 카메라 줌 레벨
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        // MARK: - 현 위치 추적 버튼
        view.showLocationButton = false
        view.showCompass = false
        view.showZoomControls = false
        
        // MARK: - NMFMapViewCameraDelegate를 상속 받은 Coordinator 클래스 넘겨주기
        view.mapView.addCameraDelegate(delegate: self)
        
        // MARK: - 지도 터치 시 발생하는 touchDelegate
        view.mapView.touchDelegate = self
        
        makeMarkers()
        checkIfLocationServicesIsEnabled()
    }
    
    deinit {
        print("Coordinator deinit!")
    }
    
    func makeMarkers() {
        for book in bookVM.books {
            if var group = userBooks[book.lenderId] {
                group.append(book)
                userBooks[book.lenderId] = group
            }
        }
        
        for user in users {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: user.latitude, lng: user.longitude)
            //marker.captionRequestedWidth = 100 // 마커 캡션 너비 지정
            //marker.captionText = user.id
            marker.captionMinZoom = 10
            marker.captionMaxZoom = 17
            marker.iconImage = NMFOverlayImage(name: "marker0")
            marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
            marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
            marker.touchHandler = { [self] (overlay) -> Bool in
                if !isMarkerTapped {
                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
                    cameraUpdate.animation = .fly
                    cameraUpdate.animationDuration = 1
                    self.view.mapView.moveCamera(cameraUpdate)
                    self.isMarkerTapped = true
                    self.currentUserId = marker.captionText
                    marker.iconImage = NMFOverlayImage(name: "marker1")
                    self.selectedMarker = marker
                }else{
                    if let selectedMarker = self.selectedMarker {
                        if selectedMarker == marker {
                            self.isMarkerTapped = false
                            selectedMarker.mapView = nil
                            marker.iconImage = NMFOverlayImage(name: "marker0")
                            marker.mapView = view.mapView
                            self.selectedMarker = nil
                        }else{
                            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
                            cameraUpdate.animation = .fly
                            cameraUpdate.animationDuration = 1
                            self.view.mapView.moveCamera(cameraUpdate)
                            selectedMarker.iconImage = NMFOverlayImage(name: "marker0")
                            marker.iconImage = NMFOverlayImage(name: "marker1")
                            marker.mapView = view.mapView
                            self.selectedMarker = marker
                        }
                    }
                }
                print("currentUserId : \(currentUserId)")
                
                return true
            }
            markers.append(marker)
        }
        
        for marker in markers {
            marker.mapView = view.mapView
        }
        
        
    }
    
    func removeMarkers() {
        while !markers.isEmpty {
            let removeMarker = markers.removeFirst()
            removeMarker.mapView = nil
        }
    }
    
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // print("카메라 변경 - reason: \(reason)")
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // MARK: - 카메라 변경 Reason 번호 별 차이
        /// 0 : 개발자의 코드로 화면이 움직였을 때
        /// -1 : 사용자의 제스처로 화면이 움직였을 때
        /// -2 : 버튼 선택으로 카메라가 움직였을 때
        /// -3 : 네이버 지도가 제공하는 위치 트래킹 기능으로 카메라가 움직였을 때
        // print("카메라 변경 - reason: \(reason)")
        
        // MARK: - 카메라 위치 변경 시 위도/경도 값 받아오기
        // let cameraPosition = mapView.cameraPosition
        // print("카메라 위치 변경 : \(cameraPosition.target.lat)", "\(cameraPosition.target.lng)")
    }
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on.")
            }
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into setting to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            print("LocationManager-coord: \(coord)")
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            print("LocationManager-userLocation: \(userLocation)")
            fetchUserLocation()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
            
            view.mapView.moveCamera(cameraUpdate)
        }
    }
    
    // MARK: - 카메라 이동
    func moveCameraPosition() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coord.0, lng: coord.1))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        HomeCoordinator.shared.view.mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - 카메라의 움직임이 완전히 끝나면 호출되는 콜백 메서드
    /// 해당 시점의 카메라 위치는 콜백 내에서 NMFMapView.cameraPosition으로 얻을 수 있습니다.
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let target = mapView.cameraPosition.target
    }
    
    // MARK: - 지도 터치에 이용되는 Delegate
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map Tapped")
        isMarkerTapped = false
        removeMarkers()
        makeMarkers()
    }
}
