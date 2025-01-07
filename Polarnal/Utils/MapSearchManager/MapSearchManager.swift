//
//  MapSearchManager.swift
//  Polarnal
//
//  Created by 최승범 on 1/6/25.
//

import Foundation
import MapKit
import Combine

final class MapSearchManager: NSObject {
    
    private var searchCompleter: MKLocalSearchCompleter? // MKLocalSearchCompleter 인스턴스, 검색 결과를 완성하는 역할
    private var searchRegion = MKCoordinateRegion(MKMapRect.world) // 검색할 영역
    var completerResults: [MKLocalSearchCompletion]? // 검색 완료된 결과 저장
    private var localSearch: MKLocalSearch? // 실제 검색을 처리하는 객체
    private var places = [MKMapItem]() // 검색된 장소 목록
    var placeTitleList = [String]()
    override init() {
        super.init()
        
        configureSearchCompleter() // searchCompleter 설정
    }
    
    /// 검색 완성기(MKLocalSearchCompleter) 설정
    private func configureSearchCompleter() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest // 관심 지점 검색
        searchCompleter?.region = searchRegion
    }
    
    /// 검색 결과를 업데이트
    func upadteCompleterResults(results: [MKLocalSearchCompletion]?) {
        completerResults = results
    }
    
    /// 검색어를 업데이트하여 검색을 실행
    func updateCompleter(query: String) {
        searchCompleter?.queryFragment = query // 검색어 설정
    }
    
    func clean() {
        searchCompleter = nil
    }
}

extension MapSearchManager: MKLocalSearchCompleterDelegate {
    
    /// 검색 결과가 업데이트되면 호출되는 메소드
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results // 결과 업데이트
        placeTitleList = []
        guard let completerResults = completerResults else { return }
        
        for locationResult in completerResults {
            placeTitleList.append(locationResult.title)
        }
//        if !completerResults.isEmpty {
//            debouncer.run { [weak self] in
//                self?.places.removeAll()
//
//                for completion in completerResults {
//                    self?.search(for: completion) // 각 검색 결과에 대해 검색 실행
//                }
//            }
//
//        }
    }
    
    /// 검색 실패 시 호출되는 메소드
    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        if let error = error as NSError? {
            print("위치 가져오기 에러 발생: \(error.localizedDescription)") // 에러 출력
        }
    }
}


//MARK: - Search

extension MapSearchManager {
    
    /// 제안된 검색 결과에 대해 실제 검색을 실행
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion) // 제안된 결과를 요청으로 변환
        searchRequest.naturalLanguageQuery = suggestedCompletion.title // 자연어 쿼리 설정
        
        search(using: searchRequest) // 검색 실행
    }
    
    /// 쿼리 문자열에 대해 검색을 실행
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request() // 새로운 검색 요청 생성
        searchRequest.naturalLanguageQuery = queryString // 자연어 쿼리 설정
        
        search(using: searchRequest) // 검색 실행
    }
    
    /// MKLocalSearch.Request 객체를 사용하여 실제 검색을 실행
    func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest // 관심 지점만 검색
        
        localSearch = MKLocalSearch(request: searchRequest) // MKLocalSearch 객체 생성
        localSearch?.start { [weak self] response, error in
            guard let self = self,
                  let mapItems = response?.mapItems else { return }
            
            if !mapItems.isEmpty {
                places.append(mapItems.first!) // 검색된 첫 번째 장소 추가
            }
        }
    }
    
    /// 검색된 장소 목록을 반환
    func placeList() -> [String] {
        var names = [String]() // 장소 이름 배열
        
        for place in places {
            if let name = place.name {
                names.append(name) // 각 장소의 이름을 배열에 추가
            }
        }
        return names
    }
}
