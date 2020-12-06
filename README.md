# VIPER

Here you can see what to do with such technology as VIPER in real life. Nowadays, as SwiftUI and Cobine annex ios development there is still a place of VIPER architecture pattern  [presentation](https://drive.google.com/file/d/1-z4mVCDbPR7Yl4pIkbIwPmh_ZnxxtaeC/view?usp=sharing) or [video](https://web.microsoftstream.com/video/3893061f-8f98-42b4-9264-34a0fb711a66).

# Main scheme
![MainScheme](/Assets/VIPER.001.jpeg)

# Protoclos

**Example**
```Swift
import Foundation

protocol MainModuleInput {
  func didPushFirst(promo: String)
}

protocol MainRouterInput {
  func didTapRedo(film: FilmCardViewData, reaction: UserReaction)
  func routeToResult(title: String, message: String)
}

protocol MainRouterOutput: AnyObject {
  func didReceiveResult(_ result: Result<UserReaction, Error>)
  
}

protocol MainViewInput: AnyObject {
    func applyState(_ state: MainViewState)
}

protocol MainViewOutput: Preparable {
  func swipeDidEnd(direction: UserReaction, rate: Float)
  func swipeDidMove(direction: UserReaction, rate: Float)
  func didTapRedo()
  func didDismissCard()
}

protocol MainInteractorInput {
  func saveReaction(id: String, reaction: UserReaction)
  func loadData()
}

protocol MainInteractorOutput: AnyObject {
  func displayNewData(data: [FilmCardPresentationData])
  func displayError(text: String)
  func displayDataEnd()
}
```

**Description**

As VIPER is based on delegation pattern and has isolated parts of module, that are boxed into protocols, everything starts from protocols

# View 

**Example**
```Swift
import SwiftUI

struct MainView: View {
  
  @EnvironmentObject var viewModel: MainViewModel
  
  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8249547592, green: 0.5403262503, blue: 0.9973048834, alpha: 1)), Color.init(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))]), startPoint: .bottom, endPoint: .top)
        .edgesIgnoringSafeArea([.top, .bottom])
      GeometryReader { geometry in
        VStack {
          Spacer()
          ZStack {
            ForEach(self.viewModel.films.reversed(), id: \.id) { film in
              if let index = self.viewModel.films.firstIndex(of: film) {
                CardView(film: film, onRemove: { film  in
                  self.viewModel.didDismissCard()
                })
                .animation(.spring())
                .frame(width: self.viewModel.getCardWidth(geometry, id: index), height: 400)
                .offset(x: 0, y: self.viewModel.getCardOffset(id: index))
              }
            }
          }.padding(.bottom, 100)
        }
      }.padding()
    }.navigationBarHidden(true)
  }
}
```
**Description**

* View transmits every event triggered by user or lifecycle with its associated data (user entries, selection) to Presenter
* Views are passive, they haven’t got any business, routing, persistence logic
* Views represent the viewModels that they received. They don’t fetch any data themselves
* It is represented by UIViewControllers, UIViews, Views and ViewModels in SwiftUI, in the case of reusable interface elements - Delegates and DataSources of them can be placed in DisplayDataSources

# State & ViewInput

**State Example**
```Swift
enum MainViewState {
  case displayHint(UserReaction)
  case finishGesture(UserReaction)
  case error(String)
  case loading
  case initial
  case newData([FilmCardViewData])
  case displayPromo(String)
  case dataEnd(String)
  case setRedoHidden(isHidden: Bool)
}
```

**ViewModel Example**
```Swift
class MainViewModel: ObservableObject, Viewable  {
  typealias State = MainViewState
  typealias Output = MainViewOutput

  init(output: MainViewOutput) {
    self.output = output
    cancellables = Set<AnyCancellable>()
  }
  
  var output: Output!
  var cancellables: Set<AnyCancellable>

  @Published var films: [FilmCardViewData] = []
  @Published var state: MainViewState = .initial
  @Published var actionTextAlignment: Alignment = .bottomTrailing
  @Published var actionText: String?
  @Published var actionTextColor: UIColor = .red
  @Published var redoIsHidden: Bool = true
 }
 
 extension MainViewModel {
  func gestureDidMove(offset: CGSize) {
    let value = self.findDestination(translation: offset)
    self.output.swipeDidMove(direction: value.direction, rate: value.rate)
  }
  
  func gestureDidEnd(offset: CGSize) {
    let value = self.findDestination(translation: offset)
    self.output.swipeDidEnd(direction: value.direction, rate: value.rate)
  }
  
  func didTapRedo() {
    output.didTapRedo()
  }
  
  func didDismissCard() {
    output.didDismissCard()
  }
}
      
  // MARK: - input

extension MainViewModel: MainViewInput {
  func bindState() {
    $state.sink { [weak self] state in
      guard let self = self else { return }
      switch state{
      case .initial:
        break
      case let .displayHint(type):
        switch type {
        case .favourite:
          self.actionTextAlignment = .topLeading
          self.actionText = self.favouriteText
          self.actionTextColor = .green
        case .dislike:
          self.actionTextAlignment = .topTrailing
          self.actionText = self.dislikeText
          self.actionTextColor = .red
        case .watchlist:
          self.actionTextAlignment = .bottom
          self.actionText = self.watchlistText
          self.actionTextColor = .blue
        case .none:
          self.actionText = nil
        }
      case let .finishGesture(type):
        self.actionText = nil
        if type == .none {
          break
        }
        self.films.remove(at: 0)
      case let .newData(films):
        self.films = films
      case let .setRedoHidden(isHidden):
        self.redoIsHidden = isHidden
      default: break
      }
    }.store(in: &cancellables)
    
    self.output.readyForInitState()
  }

  func applyState(_ state: State) {
    self.state = state
  }
}
```

**Description**

State class changes view according to presenter's command. Due to SwiftUI View's effective binding-based drawing, we construct additional ViewModel class, that conforms to ObservableObject. ViewModel + SwiftUI View + UIHostingController is fully replacable by UIKit view conroller because Presenter(as we see further) does not know about SwiftUI or UIKit. It only pass states to ViewInputable class. 


# UIKit View

**State Example**
```Swift
final class DetailViewController: UIViewController, Viewable, Origin {
  typealias State = DetailViewState
  typealias Output = DetailViewOutput
  var output: Output!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    output.readyForInitState()
  }
  
  func applyState(_ state: State) {
    switch state{
      default: return
    }
  }
}

extension DetailViewController: Constructable {
  static func construct(output: Output) -> DetailViewController {
    let vc = DetailViewController()
    vc.output = output
    return vc
  }
}

extension DetailViewController: DetailViewInput {}

extension DetailViewController: Storyboardable {}
}
```

**Description**

Here we see UIKit traditional ViewController with state appliement


# Presenter
**Example**
```Swift
final class MainPresenter: RouterInputable, ViewInputable, InteractorInputable {
  typealias ViewInput = MainViewInput
  typealias InteractorInput = MainInteractorInput
  typealias RouterInput = MainRouterInput
  var routerInput: RouterInput
  var interactorInput: InteractorInput
  unowned var viewInput: ViewInput!
  var films: [FilmCardViewData] = []
    
  init(routerInput: RouterInput, interactorInput: InteractorInput) {
    self.routerInput = routerInput
    self.interactorInput = interactorInput
  }
}

// MARK: - Init state
extension MainPresenter: Preparable {
  func readyForInitState() {
    applyInitialData()
  }
  
  func applyInitialData() {
    interactorInput.loadData()
  }
}

// MARK: - View delegate
extension MainPresenter: MainViewOutput {
  func didDismissCard() { ... }
  
  func didTapRedo() {
    guard let first = lastReactedFilm else { return }
    routerInput.didTapRedo(film: first.film, reaction: first.reaction)
  }
}

// MARK: - Module input
extension MainPresenter: MainModuleInput {
  func didPushFirst(promo: String) {
    routerInput.routeToResult(title: Const.promoTitle, message: promo)
  }
}

// MARK: - Interactor delegate
extension MainPresenter: MainInteractorOutput {
  func displayNewData(data: [FilmCardPresentationData]) {
    let films = data.map({ $0.toViewData() })
    self.films += films
    viewInput.applyState(.newData(Array(self.films.prefix(3))))
  }
  func displayError(text: String) { ... }
  func displayDataEnd() { ... }
}

// MARK: - Router delegate
extension MainPresenter: MainRouterOutput {
  func didReceiveResult(_ result: Result<UserReaction, Error>) { ... }
  }
}
```
**Description**

* Presenter manages events, maps associated data and decides what to do with them - e.g. send to interactor or open another module
* Presenter prepares data to be displayed (viewModels, viewData) and tells UI-based components to update or Router to coordinate to further modules. Displaying data is stored, if needed, for reusage
* Entities, if they are exact objects or structs, are never passed from the Interactor to the Presenter. Instead, simple data structures that have no behaviour as PresentationData are passed from the Interactor to the Presenter.

# Interactor

**Example**
```Swift
final class MainInteractor:  MainInteractorInput, Interactable {
  typealias Output = MainInteractorOutput
  weak var output: Output!
  var page = 0
  var lastPage: Int?
  var isLoadingData = false
  
  var repository: FilmRepository
  init(repository: FilmRepository) {
    self.repository = repository
  }
  
  func saveReaction(id: String, reaction: UserReaction) { ... }
  }
  
  func handleReactionResponse(_ result:Result<Void, Error>) {
    switch result{
    case let .failure(error):
      self.output.displayError(text: error.localizedDescription)
    case .success:
      return
    }
  }
    
  func loadData() {
    if let lastPage = lastPage, lastPage < page {
      self.output.displayDataEnd()
      return
    }
    guard !isLoadingData else { return }
    isLoadingData = true
    repository.getRecomendations(page: page) { [weak self] result in
      switch result {
      case let .success(data):
        guard let self = self else { return }
        self.output.displayNewData(data: data.films.map{ FilmCardPresentationData(entity: $0) } )
        self.lastPage = data.lastPage
        self.page += 1
      case let .failure(error):
        self?.output.displayError(text: error.localizedDescription)
      }
      self?.isLoadingData = false
    }

  }

}
```
**Description**

* Interactors captures data if needed, and calls dellegates from presentation layer
* Interactor decides to do any business logic methods not dependent on UI or Data and call data managers or services.
* Interactor represents a single use case in the app
* Interactor operates Entities and creates new Entities
* To help Interactors manage data of the same type, there are Services. The whole Interactor can be only facade for Services work or work directly with repositories

# Entity

**Example**
```Swift
import Foundation
struct Film {
  enum State: Int16 {
    case watched
    case dislike
    case favourite
    case undefined
  }
  let id: Int
  let internalId: AnyHashable?
  let name: String
  let info: String?
  var state: State?
  let rating:Float?
  let year: String?
  var actors: [String]
  let imageId: String?
}

extension Film: EntityIdentifiable {}
}
```

**Description**

* The DomainEntities layer mostly houses protocols defining the nouns of the application’s problem domain.
* Notice that the Presenter, Interactor, or DataManager depends to data objects solely via the Entity interface. In turn the protocol gets implemented by either Core Data objects or objects defined by network code, likely as a result of JSON parsing. The Entity interface abstracts the location where the data came from – which is a detail
* It can also contain common data types for use in subsequent layers. 
* Code in this layer must not perform I/O, hence won’t contain any code for handling files, making network requests, nor presenting a user interface. 

# Router

**Example**
```Swift
import Swinject
  
final class MainRouter: Routable, MainRouterInput{
  let locator: ApplicationLocator
  weak var origin: Origin?
  weak var output: MainRouterOutput?
  
  init(locator: ApplicationLocator) {
    self.locator = locator
  }

  func didTapRedo(film: FilmCardViewData, reaction: UserReaction) {
    guard let origin = origin,
          let module = locator.assembler.resolver.resolve(DetailModule.self)
    else { return }
    module.inputListener.film = film
    module.inputListener.reaction = reaction
    module.inputListener.onClose = { [weak self] result in
      self?.output?.didReceiveResult(result)
    }
    origin.start(transition: .push, destination: module.view)
  }
  
  func routeToResult(title: String, message: String) { ... }
}
```

**Description**

* Routers are usually wireframes or storyboards
* Router navigates and presents other modules (new screen or even included parts)
* The wireframe is also an obvious place to handle navigation transition animations. It initialises instances of each VIPER’s component and wires them up. 
* It can be separated for module builder class (assembly), and navigation handler (router)
* In router some direct or backward dependencies(as closures) are injected

# Assembly and Module wrapper

**SwiftUI Module Assembly example**
```Swift
import Swinject
import SwiftUI

final class MainAssembly: Assembly {
  func assemble(container: Container) {
    container.register(MainModule.self) { (resolver) -> MainModule in
      guard let remoteRepository = resolver.resolve(FilmRepository.self, arguments: Environment.mock, RepositoryLocation.remote)
      else { preconditionFailure() }
      let interactor = MainInteractor(repository: remoteRepository)
      let router = MainRouter(locator: ApplicationLocator.shared)
      let presenter = MainPresenter(routerInput: router, interactorInput: interactor)
      let viewModel = MainViewModel(output: presenter)
      presenter.viewInput = viewModel
      interactor.output = presenter
      router.output = presenter
      let view = MainView().environmentObject(viewModel)
      let viewController = UIHostingController(rootView: view)
      router.origin = viewController
      viewModel.bindState()
      let module = MainModule(view: viewController, inputListener: presenter)
      return module
    }
  }
}
```

**UIKit Module Assembly example**
```Swift
import Swinject

final class DetailAssembly: Assembly {
  func assemble(container: Container) {
    container.register(DetailModule.self) { (resolver) -> DetailModule in
      guard let remoteRepository = resolver.resolve(FilmRepository.self, arguments: Environment.mock, RepositoryLocation.remote) else { preconditionFailure() }
      let interactor = DetailInteractor(repository: remoteRepository)
      let router = DetailRouter()
      let presenter = DetailPresenter(routerInput: router, interactorInput: interactor)
      let viewController = DetailViewController.construct(output: presenter)
      interactor.output = presenter
      presenter.viewInput = viewController
      router.origin = viewController
      router.output = presenter
      let module = DetailModule(view: viewController, inputListener: presenter)
      return module
    }
    
  }
}
```

**Module wrapper example**
```Swift
  final class DetailModule : Modulable {
    typealias InputListener = DetailModuleInput
	let view: Origin
	var transition: Transition?
	var inputListener: InputListener

	init(view: Origin, inputListener: InputListener){
    	self.view = view
	    self.inputListener = inputListener
	}
}
```

**Description**

Here we have provided by Swinject Assembly for two approaches - SwiftUI and UIKit. ViewInput for SwiftUI-based module is ViewModel, and Origin - the UIViewController for routing - is UIHostingController. In UIKit both of them are confirmed by UIViewController's subclass.
Module wrapper has some properties - view - to present, transition - to rememer how this module was shown and inputListener to inject dependencies from routing functions in routers (they are presenters of further modules)

# Tests

**Preparing for testing Presenter examples**
```Swift
import XCTest
@testable import BestFilmForYou

class MainPresenterTests: XCTestCase {
  var routerMock: RouterMock?
  var interactorMock: InteractorMock?
  var viewMock: ViewMock?
  var sut: MainPresenter?
  
  override func setUpWithError() throws {
    let routerMock = RouterMock()
    let interactorMock = InteractorMock()
    let viewMock = ViewMock()
    self.viewMock = viewMock
    self.interactorMock = interactorMock
    self.routerMock = routerMock
    self.sut = MainPresenter(routerInput: routerMock, interactorInput: interactorMock)
    sut?.viewInput = viewMock
  }
  
  class InteractorMock: MainInteractorInput {
    func saveReaction(id: String, reaction: UserReaction) {
      self.idSignal = id
      self.reactionSignal = reaction
    }
    func loadData() {
      self.loadDataSignal = true
    }
    var loadDataSignal: Bool = false
    var idSignal: String?
    var reactionSignal: UserReaction?
  }
  
  class RouterMock: MainRouterInput{
    func didTapRedo(film: FilmCardViewData, reaction: UserReaction) {
      self.filmSignal = film
      self.reactionSignal = reaction
    }
    func routeToResult(title: String, message: String) {
      self.titleSignal = title
      self.messageSignal = message
    }
    var filmSignal: FilmCardViewData?
    var reactionSignal: UserReaction?
    var titleSignal: String?
    var messageSignal: String?
  }
  
  class ViewMock: MainViewInput {
    var newDataSignal: [FilmCardViewData]?
    var isRedoHiddenSignal: Bool?
    var finishReactionSignal: UserReaction?
    var displayHintReactionSignal: UserReaction?
    var isLoadingSignal: Bool?
    var dataEndTextSignal: String?
    func applyState(_ state: MainViewState) {
      switch state {
      case let .setRedoHidden(isHidden: isHidden):
        self.isRedoHiddenSignal = isHidden
      case let .newData(data):
        newDataSignal = data
      case let .finishGesture(reaction):
        finishReactionSignal = reaction
      case let .displayHint(reaction):
        displayHintReactionSignal = reaction
      case .loading:
        isLoadingSignal = true
      case let .dataEnd(text):
        dataEndTextSignal = text
      default: return
      }
    }
  }
  
  enum ErrorStub: LocalizedError {
    case text(String)
    case empty
    
    public var errorDescription: String? {
      switch self {
      case let .text(descr):
        return NSLocalizedString(descr, comment: "")
      case .empty:
        return NSLocalizedString("", comment: "")
      }
    }
  }
  
  override func tearDownWithError() throws {
    self.routerMock = nil
    self.interactorMock = nil
    self.viewMock = nil
    self.sut?.viewInput = nil
    self.sut = nil
  }
}
```

**Testing presenter example** 
```Swift
  func testDisplayNewData() {
    let entity = Film(id: 111, internalId: 112, name: "TestName", info: "TestInfo", state: .none, rating: 5.0, year: "1994", actors: ["TestActior"], imageId: nil)
    let film = FilmCardPresentationData(entity: entity)
    sut?.displayNewData(data: [film, film, film, film])
    XCTAssertEqual(viewMock?.newDataSignal?.count, 3)
    XCTAssertEqual(viewMock?.newDataSignal?.first?.id, "\(film.internalId)")
  }
```

# Generamba

**Example**
```Swift
{% include 'header' %}

final class {{ module_info.name }}Presenter: RouterInputable, ViewInputable, InteractorInputable {
    typealias ViewInput = {{ module_info.name }}ViewInput
    typealias InteractorInput = {{ module_info.name }}InteractorInput
    typealias RouterInput = {{ module_info.name }}RouterInput
    var routerInput: RouterInput
    var interactorInput: InteractorInput
    unowned var viewInput: ViewInput!
    
    init(routerInput: RouterInput, interactorInput: InteractorInput) {
        self.routerInput = routerInput
        self.interactorInput = interactorInput
    }
}

extension {{ module_info.name }}Presenter: Preparable {
    func readyForInitState() {
    }
}

extension {{ module_info.name }}Presenter: {{ module_info.name }}ViewOutput {
    
}

extension {{ module_info.name }}Presenter: {{ module_info.name }}ModuleInput {
    
}

extension {{ module_info.name }}Presenter: {{ module_info.name }}RouterOutput {
}

extension {{ module_info.name }}Presenter: {{ module_info.name }}InteractorOutput {
}
```

**Description** 
This is the example for generamba template .liquid source file. In is used in .rambaspec file where such liquid sources are put into one template

**Rambaspec example**
```
# Template information section
name: assembly_viper
summary: VIPER module with assembly and protocols
version: 1.0.0

# The declarations for code files
code_files:
# Presenter layer
- {name: Presenter/Presenter.swift, path: Code/Presenter/presenter.swift.liquid}

# Template dependencies
dependencies:
- Swinject
```

**Installing generamba and create module axample**
```sh
 generamba setup 
  #Add all templates planned to use in the project to the generated Rambafile, like assembly_viper
  generamba template install
  #All the templates will be placed in the '/Templates' folder of your current project.
  generamba gen [MODULE_NAME] [TEMPLATE_NAME]
```

# Summary 
**VIPER can be Clean-based architecture:**
 - Entities are Domain model objects (do not confuse with Persisted or fetched and Presentation data)
 - Interactors are representatives of business logic separated to classes - various use cases
 - The Application logic layer - Presenters, Routers, and Data facades - Managers, Services protocols
 - The framework-dependent layer - Views, DataStore (UIKit, SwiftUI, SiriKit, CoreData, NSURLSession)

**The main rules**
* VIPER is an architectural pattern like MVC or MVVM, but it separates the code further by single responsibility. Viper implements Single responsibility principle. It separates business-logic from displaying and creates models and rules independent from application. Mostly like MVP or MVC it follows a modular approach. 
* Viper is created to off-load VCs and improve testability, manage dependencies across classes, but don’t resolve architecture questions - dependency of the module, coupling and decoupling parts, bottlenecks,  flexibility,  data transferring, data flow, feasibility
* VIPER prescribes how to structure a GUI application into classes that are grouped in a certain way, in which those groups are elements of the VIPER acronym. 4. * However you can create a project having VIPER classes that doesn’t comply with Clean Architecture.
* REMEMBER that confirming to VIPER-acronym separation is not obligatory, you can put in module every number of layers

Developed By
------------

* Azarenkov Sergey, Vlad Kosyi, CHI Software

License
--------

Copyright 2020 CHI Software.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
