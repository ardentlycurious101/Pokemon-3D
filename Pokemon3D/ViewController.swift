//
//  ViewController.swift
//  Pokemon3D
//
//  Created by Elina Lua Ming on 8/13/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.detectionImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Image successfully added.")
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       
        let node = SCNNode()
        
        DispatchQueue.main.async {
            
            if let imageAnchor = anchor as? ARImageAnchor {
                
                print(imageAnchor.referenceImage.name!)
                
                let plane = SCNPlane(
                    width: imageAnchor.referenceImage.physicalSize.width,
                    height: imageAnchor.referenceImage.physicalSize.height
                )
                
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = (Float.pi/2)
                
                node.addChildNode(planeNode)
                
                if imageAnchor.referenceImage.name == "jigglypuff-card" {

                    if let pokeScene = SCNScene(named: "art.scnassets/jigglypuff.scn") {

                        if let pokeNode = pokeScene.rootNode.childNodes.first {

                            //  pokeNode.eulerAngles.x = -.pi/2
                            planeNode.addChildNode(pokeNode)

                        }

                    }
                    
                }
                
                if imageAnchor.referenceImage.name == "bulbasaur-card" {
                    
                    if let pokeScene = SCNScene(named: "art.scnassets/bulbasaur.scn") {
                        
                        if let pokeNode = pokeScene.rootNode.childNodes.first {
                            
                            pokeNode.eulerAngles.x = -.pi/2
                            planeNode.addChildNode(pokeNode)
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        return node
        
    }
}
