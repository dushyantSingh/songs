//
//  SceneDelegate.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: winScene)
        let initialViewController = UIViewController.make(viewController: SongViewController.self)

        let service = SongService()
        let songDownloader = SongManager()
        initialViewController.viewModel = SongViewModel(service: service,
                                                        songDownloader: songDownloader)
        let navController = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
}

extension UIViewController {
    static func make<T>(viewController: T.Type) -> T {
        let viewControllerName = String(describing: viewController)

        let storyboard = UIStoryboard(name: viewControllerName, bundle: Bundle(for: viewController as! AnyClass))

        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Unable to create ViewController: \(viewControllerName) from storyboard: \(storyboard)")
        }
        return viewController
    }
}
