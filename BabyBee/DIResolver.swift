import Swinject
import SwinjectStoryboard

enum DiError: Error, CustomStringConvertible {
    var description: String {
        switch(self) {
        }
    }
}

extension Container {
    func registerHelpers() -> Container {
        let container = self
        container.register(AppDelegateServiceDispatcher.self) { r in
            let services : [UIApplicationDelegate] =
                [
                    RootService(),
                    GoogleAnalyticsService(),
                    FirebaseNotificationService(),
                    FirebaseService(),
                    StoryKitService()
            ]
            return AppDelegateServiceDispatcher(services: services)
        }
        container.register(UserDefaults.self) { r in
            return UserDefaults.standard
        }
        container.register(CGLocalStorageInMemory.self) { r in
            return CGLocalStorageInMemory()
        }
        container.register(CGAnalyticsTracker.self) { r in
            return CGAnalyticsTracker()
        }
        container.register(CGFabricRequestContent.self) { r in
            return CGFabricRequestContent()
        }
        return container
    }
}

extension Container {
    func registerServices() -> Container {
        let container = self
        
        container.register(CGImageService.self) { r in
            let imageService = CGImageService()
            imageService.fabricRequest = r.resolve(CGFabricRequestContent.self)
            return imageService
        }
        
        container.register(CGCatalogServiceProtocol.self) { r in
            
            let catalogService = CGCatalogServiceFirebase()
            
            catalogService.localStorage = r.resolve(CGLocalStorageInMemory.self)
            catalogService.fabricRequest = r.resolve(CGFabricRequestContent.self)
            catalogService.imageService = r.resolve(CGImageService.self)
            return catalogService
        }
        return container
    }
}

extension Container {
    fileprivate static func registerMainScreen(in container: Container) {
        container.register(CGMainScreenDDM.self) { (r, delegate: CGMainScreenDelegate, catalog: CGCatalogModel) in
            return CGMainScreenDDM(delegate: delegate, catalog: catalog)
        }
        container.storyboardInitCompleted(CGMainScreenViewController.self) { r, mainScreen in
            mainScreen.catalogService = r.resolve(CGCatalogServiceProtocol.self)
            mainScreen.tracker = r.resolve(CGAnalyticsTracker.self)
            mainScreen.userDefaults = r.resolve(UserDefaults.self)
            
            container.register(CGMainScreenViewController.self) { _ in
                return mainScreen
            }
        }
    }
    fileprivate static func registerContentScreen(in container: Container) {
        container.storyboardInitCompleted(CGContentScreenViewController.self)
        { r, contentScreen in
            contentScreen.service = r.resolve(CGCatalogServiceProtocol.self)
            contentScreen.tracker = r.resolve(CGAnalyticsTracker.self)
            contentScreen.fabricRequest = r.resolve(CGFabricRequestContent.self)
            
            container.register(CGContentScreenViewController.self) { _ in
                return contentScreen
            }
        }
    }
    fileprivate static func registerGamesScreen(in container: Container) {
        
        container.register(CGGamesScreenDDM.self) { (r, delegate: CGGamesScreenProtocol, catalog: CGCatalogModel, group: CGGroupModel) in
            return CGGamesScreenDDM(delegate: delegate, catalog: catalog, group: group)
        }
        
        container.storyboardInitCompleted(CGGamesScreenViewController.self)
        { r, gamesScreen in
            gamesScreen.tracker = r.resolve(CGAnalyticsTracker.self)
            
            container.register(CGGamesScreenViewController.self) { _ in
                return gamesScreen
            }
        }    }
    
    func registerViewControllers() -> Container {
        let container = self
        
        Container.registerMainScreen(in: container)
        Container.registerGamesScreen(in: container)
        Container.registerContentScreen(in: container)
        
        return container
    }
}

final class DIResolver: NSObject {
    fileprivate static let r = DIResolver()
    fileprivate var container: Container!
    
    deinit {
        print("deinit DI Container")
    }
    
    static func resolve<T>(_ type: T.Type) -> T {
        return r.container.resolve(type)!
    }
    
    static func resolve<T, Arg1, Arg2, Arg3>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T? {
        return r.container.resolve(type, arguments: arg1, arg2, arg3)
    }
    
    static func resolve<T, Arg1, Arg2>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2) -> T? {
        return r.container.resolve(type, arguments: arg1, arg2)
    }
    
    static func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        return r.container.resolve(type, argument: argument)!
    }
    
    static func register<T>(_ instance: T) {
        r.container.register(T.self) { _ in instance }
    }
    
    static func createMainStoryboard() -> UIStoryboard {
        return SwinjectStoryboard.create(name: "Main", bundle: nil, container: r.container)
    }
    
    fileprivate static func diContainer() throws -> Container {
        let container = Container()
            .registerHelpers()
            .registerServices()
            .registerViewControllers()
        
        return container
    }
    override init() {
        super.init()
        do {
            self.container = try DIResolver.diContainer()
        } catch(let error) {
            print("error inside \(error)")
        }
    }
}
