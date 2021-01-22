//
//  SearchCityViewModel.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/11.
//


import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

protocol SearchCityViewPresentable {
    
    typealias Input = (
        searchText: Driver<String>, (),
        citySelect: Driver<CityViewModel>
    )
    typealias Output = (
        cities: Driver<[CityItemsSection]>, ()
    )
    typealias ViewModelBuilder = (SearchCityViewPresentable.Input) -> SearchCityViewPresentable
    
    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {
    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output
    private let airportService: AirportAPI
    
    private typealias RoutingAction = (citySelectedRelay: PublishRelay<Set<AirportModel>>, ())
    private let routingAction: RoutingAction = (citySelectedRelay: PublishRelay(), ())
    
    typealias Routing = (citySelected: Driver<Set<AirportModel>>, ())
    
    lazy var router: Routing = (citySelected: routingAction.citySelectedRelay.asDriver(onErrorDriveWith: .empty()), ())
    
    private let bag = DisposeBag()
    
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    private let state: State = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())
    
    init(input: SearchCityViewPresentable.Input,
         airportService: AirportAPI) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input,
                                                 state: self.state)
        
        self.airportService = airportService
        self.process()
    }
}

extension SearchCityViewModel {
    
    static func output(input: SearchCityViewPresentable.Input, state: State) -> SearchCityViewPresentable.Output {
        
        let searchTextObservable = input.searchText
            .debounce(RxTimeInterval.milliseconds(300)) // 幾秒內輸入
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        let airportsObservable = state.airports
            .skip(1)
            .asObservable()
    
        let sections = Observable
            .combineLatest(searchTextObservable, airportsObservable)
            .map { (searchKey, airports) in
                return airports.filter { (airport) -> Bool in
                    !searchKey.isEmpty &&
                        airport.city!.lowercased().replacingOccurrences(of: " ", with: "").hasPrefix(searchKey.lowercased())
                }
            }
            .map({
                SearchCityViewModel.uniqueElementFrom(array: $0.compactMap({ CityViewModel(model: $0) }))
            })
            .map({ [CityItemsSection(model: 0, items: $0)]  })
            .asDriver(onErrorJustReturn: [])
            
        return (
            cities: sections, ()
        )
    }
    
    func process() -> Void {
        self.airportService
            .fetchAirports()
            .map {
                Set($0)
            }
            .map { [state] in
                state.airports.accept($0)
            }
            .subscribe()
            .disposed(by: bag)
        
        self.input.citySelect
            .map { $0.city }
            .withLatestFrom(state.airports.asDriver()) { ($0, $1) }
            .map { (city, airports) in
                airports.filter { $0.city == city }
            }
            .map { [routingAction] in
                print("Airports selected: \($0)")
                routingAction.citySelectedRelay.accept($0)
            }
            .drive()
            .disposed(by: bag)
    }
}

private extension SearchCityViewModel {
    
    static func uniqueElementFrom(array: [CityViewModel]) -> [CityViewModel] {
        var set = Set<CityViewModel>()
        // 返回第一個值
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        
      return result
    }
    
}
