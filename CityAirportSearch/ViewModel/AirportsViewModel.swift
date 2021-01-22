//
//  AirportsViewModel.swift
//  CityAirportSearch
//
//  Created by ktrade on 2021/1/15.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias AirportItemsSection = SectionModel<Int, AirportViewPresentable>

protocol AirportsViewPresentable {
    typealias Output = (
        title: Driver<String>,
        airports: Driver<[AirportItemsSection]>
    )
    typealias Input = (
        selectAirport: Driver<AirportViewPresentable>, ()
    )
    
    typealias Dependencies = (
        title: String,
        models: Set<AirportModel>,
        currentLocation: Observable<(lat: Double, lon: Double)?>
    )
    
    typealias ViewModelBuilder = (AirportsViewPresentable.Input) ->  AirportsViewPresentable
    
    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

class AirportsViewModel: AirportsViewPresentable {
    
    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input
    
    private let bag = DisposeBag()
    
    private typealias RoutingAction = (airportSelectRelay: PublishRelay<AirportModel>, ())
    private let routingAction = (airportSelectRelay: PublishRelay<AirportModel>(), ())
    
    typealias Routing = (airportSelect: Driver<AirportModel>, ())
    lazy var router: Routing = (airportSelect: routingAction.airportSelectRelay.asDriver(onErrorDriveWith: .empty()), ())
    
    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
        self.process(dependencies: dependencies)
    }
    
}

private extension AirportsViewModel {
    
    static func output(dependencies: AirportsViewPresentable.Dependencies) -> AirportsViewPresentable.Output {
        
        let sections = Observable.just(dependencies.models)
            .withLatestFrom(dependencies.currentLocation) { (models:$0, location: $1) }
            .map { arg in
                arg.models
                    .compactMap { AirportViewModel(
                        usingModel: $0,
                        currentLocation: arg.location ?? (lat: 0, lon: 0)
                    )
                    }
                    .sorted()
            }
            .map {
                [AirportItemsSection(model: 0, items: $0)]
            }
            .asDriver(onErrorJustReturn: [])
        
        return (
            title: Driver.just(dependencies.title),
            airports: sections
        )
        
    }
    
    func process(dependencies: AirportsViewPresentable.Dependencies) {
        
        self.input
            .selectAirport.map { [models = dependencies.models] viewModel in
                models.filter({ $0.code == viewModel.code }).first
            }
            .filter({ $0 != nil})
            .map {
                $0!
            }
            .map({ [routingAction] in
                routingAction.airportSelectRelay.accept($0)
            })
            .drive()
            .disposed(by: bag)
    }
    
}
