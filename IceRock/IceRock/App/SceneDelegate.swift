import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if AuthManager.shared.isUserLoggedIn && !AuthManager.shared.isTokenExpired {
            window.rootViewController = UINavigationController(rootViewController: GalleryVC())
        } else {
            window.rootViewController = LoginVC()
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
