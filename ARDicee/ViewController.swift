//
//  ViewController.swift
//  ARDicee
//
//  Created by Jeff on 10/21/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: - Note 9 A: How to annimate and roll all the 3D dice at once. Create an array tha stores all the dice created at the top of the file. Create a var property that holds an array of SCNNode, initilized as an empty array., 'var diceArray = [SCNNode]()'. Refer to Note 9 B.
    
    var diceArray = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Note 5 D: 'self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]'. Refer to Note 5 E.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        //MARK: - Note 3 A: How to createa 3D object in AR. So at this point we're using a lot of template code from Apple. Start by commenting out 'let scene' and 'sceneView.scene = scene'. Essentially this is creating a scene from our ship.scn and then putting that scene into our sceneView. Now lets create our very own 3D cube object so our width and height being the same: 'let cube = SCNBox(width: CGFloat, height: CGFloat, lenght: CGFloat, chamferRadius: CGFloat)'. The 'chamferRadius' is how rounded you want the corners of the cube to be. 'let cube = SCNBox(width: 0.1, height: 0.1, lenght: 0.1, chamferRadius: 0.01)' the CFGloat units are in meters. The cube by default will have a white matte texture. Lets jazz up this boring texture, make: 'let material = SCNMaterial()'. So everything with SCN... is from SceneKit and also why its preceded with SCN (scene). Now lets change one of the scenes properties in the new 'material' object we just created. 'material.diffuse.contents = UIColor.red' .diffuse is the base material of the object; and we'll set it to a UIColor. Finally. add this new material to the cube, 'cube.materials = [materials]'; here we can see that .materials takes an array of SCNMaterials so this means you can assign multiple materials to the same object, ie. shininess, matallicness, texture, etc. but we just want to make ours red. Next, we'll create our first node, or SCNNodes, which are points in 3D space. You can assign a position in 3D space and the give it an object. Create a new object from SCNNode, 'let node = SCNNode()' and give it a position, 'node.position = SCNVector3(x: Float, y: Float, z: Float)' the .position is of time SCNVector3 which is a three-dimensional vector which has X axis (left and right), Y axis (up and down) and Z axis (towards or away). Select the overload (the autocomplete) which takes three flaots. 'node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)' on the horizontal axis keep it in the center, on the Y or vertical axis 0.1 (10 centimeters up) just above the center and Z axis -0.5 (the negative is away from you). Now that our node has a position lets add the geometry which is the cube we created earlier. 'node.geometry = cube'. To recap, first, we created this geometry called 'cube' with a method from SCN framework, 'SCNBox', gave it dimentions, then we created a red material, then assigned it to 'cube.materials' array property, then we created a node and gave it a position, finally, assigned that node a geometry. Now add this to our scene view, 'sceneView.scene.rootNode.addChildNode(child: SCNNode)' which will become 'sceneView.scene.rootNode.addChildNode(cube)'. So we are adding a childNode to our rootNode in our 3D scene. So for any given scene you can have a bunch of childNodes ex. box, with a sphere or spaceship with alien invaders. If you look in the art.scnassets you can see the rootNode as 'ship' expand that you can see the childNode called 'shipMesh' this is the ship you see on scene and then that shipMesh itself has a childNode called 'emitter' this node is used to display effects ex. smoke or fire coming out of the back. Run the app and you'll see that the cube has a flat feel to it. To make it more 3D you'll need to add highlights and shadows, with one line of code, 'sceneView.autoenableDefaultLighting = true'.
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIColor.red
//
//        cube.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3(0.0, 0.1, -0.5)
//
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
        
        
        //MARK: - Note 4 B.: Now, in our ViewController, add some code to bring our dice into our app. Comment out the code that's realted to the cube/sphere. Then uncomment the code that from earlier that rendered the plane. Next, delete or leave it commented: 'sceneView.scene = scene'. Update the directory from '.../ship.scn' to '/diceCollada.scn'. Store this in a constant, 'let diceScene = SCNScene(names: "art.scnassets/diceCollada.scn")!'. Then create a node, the 3D position to place the dice. 'let diceNode = diceScene.rootNode.childNode(withName: String, recursively: Bool)'. Update 'withName: "Dice"', to find this name look in the assets folder, diceCollada file, select the dice node and in the Identity pane you'll see its 'Name'. Copy and paste this into the 'withName: "Dice"' parameter. So this reads that; now, we'll look for a childNode inside the rootnode, of the diceScene which is created from the "art.scnassets/diceCollada.scn" file. Finally update, 'recursively: true'. What that means is it'll search through the tree and include all of the subtrees in the childNode. For example, if the ship.scn you can see the different levels of childNodes from emmiter to shipMesh, shipMesh to ship. It'll go throuch all level to find the name, in our case, "Dice". 'let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true)'. Next, we need to give it a position. We do this by calling: 'diceNode?.position = SCVector3(x: 0.0, y: 0.0, z: -0.1)'. Next, tap into the sceneView: 'sceneView.scene.rootNode.addChildNode(diceNode)' Here we can see that 'diceNode?.position' is an optional chain, and thats because the "Dice" file may not exist, may equal to nil. So, here we're checking to see if diceNode exits and then set its position. However, this doesn't handle the diceNode that goes into the sceneView; so if its nil, our app would crash. Not the best practice to force unwrap it: '(diceNode!)' as it can lead to more problems. Instead, unwrap the optional diceNode with an if statment, and wrap the call to 'diceNode' lines inside the if statment and now you can remove the optional chaining because in order to enter the block, the diceNode has to equal something.
        
        sceneView.autoenablesDefaultLighting = true
        
        
            
        //MARK: - Note 3 B: Bring the moon into your living room using AR. Lets start by calling a sphere, 'let sphere = SCNSphere(radius: 0.2)', and give it a radius, 20 centimeteres, 40 centimeters in diameter. Replace the call to 'cube' to 'sphere' with the materials property and geometry. A website called, solarsystemscope.com, has high res images of the solar system. Downlaod the moon in extreme res and then drag, moon.jpg (picture of a sphere planet laid flat), into art.scnassets folder. Update 'UIColor.red' to 'UIImage(named: "art.scnassets/moon.jpg"', with a texture map, and navigate to the file which is not in the same hierarchy as our ViewController, its resting inside the art.scnassets folder; copy and past the ship.scn directory and change file name from ship.scn to 'moon.jpg'. Now, this will drape or texture map onto our sphere.
        
        //MARK: - Note 5 A: How to detect Horizontal Planes in the real world. First comment out the dice for now. So we can focus on detecting the horizontal plane.
        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//            diceNode.position = SCNVector3(0.0, 0.0, -0.1)
//
//            sceneView.scene.rootNode.addChildNode(diceNode)
//
//        }
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //MARK: - Note 5 B: How to detect Horizontal Planes in the real world. Lets add another property to the configuration: 'configuration.planeDetection = .horizontal'. .horizontal is an enum; later, Apple will add a .vertical enum (vs .true which may only indicate one plane).
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Note 6: How to detect touches on real world 3D objects. Adding a delegate method 'touchesBegan(_ touches: Set<UITools>, with event: UIEvents?)' and this gets called when a touch is detected in the view. '_ touches' is what we're going to be receiving those touches coming in from the user. ARKit converts it into real wrold locations. First, check if indeed touches were detected and not just called in error. To do this: 'if let touch = touches.first' we only want the first object the user touched on the screen (option click touches and read doc to enable multi touch and detection). So, if 'touches.first' does contain an object then we're going to assign it to 'touch' and use it to determin its location. Create another object to detect its location: 'let touchLocation = touch.location(in: SKNode)'. The 'in: SKNode' is where the location was dected; option click location to see that its expecting a node that was decendant of a scene present in the window that receives the touch event; our sceneView: 'let touchLocaiton = touch.location(in sceneView)'. In order to convert a 2D touch location on the screen to a 3D location insdie our sceneView, use a method from ARKit called 'hitTest'. This will place an object onto a 3D coordinate that corresponds to a ARPlaneAnchor. 'hitTest(point: CGPoint, types: ARHitTestResult.ResultType)'. This expects our 'touchLocation' and the 'types', which is the result we're looking for. 'let results = sceneView.hitTest(touch, types: .existingPlaneUsingExtent)' .existingPlaneUsingExtent is a plane anchor already in the scene, representing the plane's limted size. This method call was deprecated in iOS 14 and should be replaced, according to stackOverFlow, by this: 'let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode : 1])'. So, hit testing works by: When your app is running and you tap a point on your screen, that tap is interperted as a touch location and will trigger the touchesBegan method. This will look for the location of that touch in 2D space with an x and y component on the iDevice screen. We want to convert this 2D location and let it traverse throuch the camera image and hit a point in 3D space, a place on our plane that we've already added to the scene. This will give it its 3 location in 3D space. Depending on the z component, your object, in our case the dice, will render larger or smaller, it'll scale to reality based on the z distance relative to the device. So, if z was closer to you it'll scale larger, and if it was further it will be smaller. Read more about Apples different ARHitTest by reading the doc for its parameters, methods and how it works behind the scenes. To test our hitTest after we get our result, print out 'if !results.isEmpty { print("touched the plane")} else { print("touched somewhere else")}', we're using .isEmpty because 'results' is an array type; add the '!' to revers it, and now we're checking to see, if results is not empty.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
//            if !results.isEmpty {
//                print("touched the plane")
//            } else {
//                print("touched somewhere else")
//            }
            
            //MARK: - Note 7 A: How to place dice in 3D using touch. Instead of printing the hitTest when a plane was touched lets print out the actual hitTest result. Comment out the print lines. Looking at the console and inside the result which have a few components, look for the 'worldTransform=<translatiion=(...) which as a 3D position with x, y, and z position. Now we want to place the dice onto the real world where the user touched. Use the code from ealier where we positioned the dice anywhere in front of us at a fixed location, move the code here by replacing the 'print'. So, this is the same as we did before: creating a dice scene using our diceCollada.scn file, then creating a diceNode using the dice object inside our diceScene and then giving it a position. The position coordinates has to be replaced by real world position of the touch that's on the dected plane: 'SCNVector3(hitresults.worldTransform.columns.3.x)', and addtional respective to y and z. Making the call the columns and its 4th corresponds to positions and we tap into the x component of that column which is the x position. The other columns give us things like rotation, scale. When you see the object appear on the scene you can see half the object is flushed against the surface, that's because we're using the position of the the y plane which starts against the surface and so the objects y center will start there so the coordinate needs to be readjusted to add half of the height of the dice in order to raise it so it sits flush on the surface of the plane: '+ diceNode.boundingSpehere.radius' add this to the y.
            if let hitResult = results.first {
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
        
                    diceNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, hitResult.worldTransform.columns.3.z)
                    
                    //MARK: - Note 9 B: Append it to an array just before we put it onto the scene: 'diceArray.append(newElement: SCNNode)', updated to, 'diceArray.append(diceNode)'. Now we'll have an array of all the dice nodes and loop through the array and spin them at once by creating a new method: 'func rollAll'. Refer to Note 9 C.
                    diceArray.append(diceNode)
        
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                        //MARK: - Note 8: How to animate 3D objects in AR. To get a random number to appear on the dice, we need to be able to rotate it around the x and z axis. Create a random number object: 'let randomX = arc4random_uniform(__upper_bound: UInt32)', 'let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)'. Here we set the upper bound to 4 and shifted it by 1 so we can rotate it around the x axis and have all four faces appearing equally. Then its multiplied by '* Float.pi/2', this means, half of pi is 90 degrees and each dice turn is 90 degrees showing a new face. Also, 'arc4random_uniform' is an UInt32 but it needs to be casted inside a 'Float()'. Now use exactly the same code to create one for the z azis: 'let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)' The y axis can be ignored beacuse rotaion around the y axis always gives you the same face value of the dice and wont change our outcome. Now the random degress of rotation are set on the x and z axis. Next, run it as an animation and SceneKit has a special method, runAction, which can be put onto the 'diceNode' that was added into the sceneView: 'diceNode.runAction(action: SCNAcction)', updated to, 'diceNode.runAction(SCNAction.rotateBy(x: CGFloat, y: CGFloat, z: CGFloat, duration: TimeInterval), updated to, 'diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)'. To make it look more like a spnning dice update the random number objects by '* 5' to increase the number of complete rotations the dice makes.
//                    let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
//
//                    let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
//
//                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
                    
                    roll(dice: diceNode)
        
                }
            }
        }
    }
    
    //MARK: - Note 9 C: Create a method called 'rollAll()' which takes no parameters. 'func rollAll() { if !diceArray.isEmpty { for dice in diceArray { roll(dice: dice) }}}' , if diceArray is empty--is false, denoted by '!', for every dice inside diceArray, lets loop through that array and call a function called 'roll(dice: SCNNode)' that takes a single SCNNode as a parameter. The function called 'roll(dice: dice)' needs to be created. Refer to Note 9 D.
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    //MARK: - Note 9 D: Create the function with a parameter type that'll accept SCNNode: 'func roll(dice: SCNNode) { }'. Transplant the random number code into this function block and call this function from where the code was trasnsplanted from. 'func roll(dice: SCNNode) { let randomX = (arc4random_uniform(4) + 1) + (Float.pi/2) let randomZ = (arc4random_uniform(4) + 1) + (Float.pi/2)  diceNode.runAaction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))}'. Now that it's its on very method we can call this code from multiple places apart from, where it was transplated from--replaced by: 'roll(dice: diceNode)' Remember to update the method call parameter name in the new method from 'diceNode.runAction' (as this no longer exists and renamed) to 'dice.runAction'. Refer to Note 9 E.
    func roll(dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))

    }
    
    //MARK: - Note 9 E: Next, go to Main.storyboard and add a button for the function rollAll. Embed the ViewController inside a Navigation Controller by: Editor > Embed In > Navigation Controller. Add a 'bar button item' to the top right nav. bar. Link up this button to an IBAction called 'rollAgain'; update type to UIBarButtonItem. Update the buttons image to system item, Refresh symbol (clockwise arrow). Inside this IBAction, call, { 'rollAll()' }. Instead of placing the roll all code inside this funciton, you can call the 'rollAll()' method inside a another function which detects shakes and implement the method. Also, its just better practice to sperate out discrete functionality into different methods. To detect if the device shook, add the method, 'override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) { rollAll() }. Call 'rollAll()' to roll all the dice on the screen.
    
    
    //MARK: - Note 10: How to remove the 3D object from the AR scene. To do this add another bar button item to the upper left side of the navigation controller. (To give the nav bar a title, inside the attribute inspector, Title, ARDicee.). Link it up as another IBAction, call it: removeAllDice, update Connection to an Action, and type to a UIBarButtonItem, Connect. Use a system icon symbol, Trash. Implement code to remove the dice: 'if !diceArray.isEmpty { for dice in diceArray { dice.removeFromParentNode()}' (if diceArray.empty is false then loop through all the dice in the dice array and remove each node from the parent node.).
    
    
    //MARK: - Note 5 C: Add a delegate method from ARSCNViewDelegate. If you start typing with the ARSCNViewDelegate adopted, then auto complete will trigger while typing, "didAdd": 'func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)', this basically means its detected a horizontal surface and its given that surface a width and height (an AR anchor). Inside this method is where to set up the horizontal plane. So when a new horizontal plane is detected, it'll call this method and trigger the code thats inside. Also, we'll receive an object from 'anchor: ARAnchor', visualize this as a tile on the horizontal plane to be used to place object(s). It has a whole bunch of coordinates (dimensions, position, rotation) of that plane to place our object. The object will be placed on the real world coordinates of that plane. This anchor helps us do this but its also a broad category of anchors, we want to check to see if its of type ARPlaneAnchor. To do that, run a check to see if the new added 'anchor: ARAnchor' is of the type ARPlaneAnchor, ie. its from our '.planeDetection': { if anchor is ARPlaneAnchor { print("plane detected") } else { return } }'. If it's true, it detectes a plane, it'll print, otherwise, it'll exit from the method call. You may notice a bit of delay before it detects a plane, enable a debug option which will show you as it's trying to look for points in the view that are lining up to form a plane: 'self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]'; this is an array with one item in it. Add this to the method 'func viewDidLoad()'. Refer to Note 5 D.
    //MARK: - Note 5 E: These feature points will not work on shiny metallic objects, ie a mirror. Otherwise, a soft fabric with creases and casts a bit of a shadow which provides a bit more texture to the plane helps the detection happens a bit faster. Replace the 'print("Plane Detected")' with a downcast from a broader type to a more specific (think: lower or child or subclass) type, ie. ARPlaneAnchor): 'let planeAnchor = anchor as! ARPlaneAnchor'. So. this code will check to see if the parameter 'anchor:' is of type ARPlaneAnchor and if it is then it will change its type to ARAnchor to ARPlaneAnchor. This code is very expressive and can be succinct but we'll refactor it later so to grasp the abstract ideas better now. Next, convert the dimensions of our anchor into a 'SCNPlane' (similar to how a SCNBox or SCNSphere was created): 'let plane = SCNPlane(width: CGFloat, height: CGFloat)'. This requires two methods: width, height; the type ARPlaneAnchor has a property called '.extent' that comprises a width and height. This new "tile" plane can be converted into something that can be used with SceneKit so we can render our sceneView. So, 'let plane = SCNPlane(width: planeAnchor.extent.x, height: planeAnchor.extent.z)'. Its important to notice that we have an x-axis and a z-axis (no y-azis). Option, click, .extent to read the documentaion: this is a estimated width and length of a detected plane. The property type is vector_flaot3 (a 3D object) but plane anchor is always 2 dimensional and always positioned in the x and z directions. Next, address the error Xcode is giving us: cannot convert type to CGFloat, so cast it as a CGFloat by pressing the Fix option. 'width: CGFloat(planeAnchor.extent.x)'. Next, create a node, a planeNode, 'let planeNode = SCNode()', then, set the planeNode.position property: 'planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)'; the y anchor is set to 0 because we want to use the horizontal plane we deceted and set it on its surface and not higher or lower. Now, heres a tricky concept, the SCNPlane is created on a vertical plane (in the x and y axis), this needs to be converted horizontal (x and z axis). In ARKit, on the sceneView, eveything is 3D but our plane is horizontal plane so we need to convert this to the vertical plane. To do this transfrom, rotate it 90 degrees: 'planeNode.transform = SCNMatrix4MakeRotation(angle: Float, x: Float, y: Float, z: Float)', this takes 4 parameters: the angle to rotate it by, then the next three are the axis to rotate the object. 'angle: Float' is in radians, in math 1pi radian = 180 degrees; to rotate by 90 degrees use 1/2pi radians use: 'Float.pi/2' (avilable through UIKit). By default this is rotated counter clockwise placing our points in the negative axis but to place it in the positive, rotate clockwise by adding a '-Float.pi/2'. Next, specify the axis to rotate it aournd, the x axis; so our rotation only has an x '(-Float.pi/2, x: 1, y: 0, z: 0)', the other two are 0 or left blank. For our human eyes to evaluate if the plane created is correct, add the Apple provide grid.png file (.png files are transparent). To visualize these planes use the grid material which will display when its finished detecting a plane. Drag and drop the grid into the art.scnassets folder. Then create a new constant: 'let gridMaterial = SCNMaterial()', 'gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")'. Then, assign this material to our planeGeometry: 'plane.materials = [gridMaterial]'. Then, set the geometry of our planeNode: 'planeNode.geometry = plane'. Finally, set our childNode into our rootNode. So as part of this deligate method, we have this parameter called 'node: SCNNode', giving us a blank node to work with (vs calling, 'sceneView.SCNRootNode.childNode'): 'node.addChildNode(planeNode). Next lession, is about how to implement touch in the scene because, we want to be able to touch a position on the plane and place an object in the 3D world and scaled realistically.
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
}


//MARK: - Note 1: Intro to Augmented Reality and ARKit. Example apps include: 2d Stickers in instagram stories, snapchat filters, pokemon go and the failed company Magic Leap. ARKit is a way of implementing augmented reality in iOS in a simplified way. Its a way for your app to display virtual content together with a live camera image, then the user basically experiences augmented reality. The hardware needs to support world tracking so A9 chip and greater.

//MARK: - Note 2 A: Set up and configure AR project. Create a new AR app in iOS, select the content technology as SceneKit; other include: SpriteKit, Metal, RealityKit. Metal is a GPU accelerated graphics API that lets you get close to controlling the GPU. The phrase, "coding close to the metal" refers to metal, being the computer and you pushing hardware to the limit with the Metal API (similar to OpenGL). SpritKit (made for 2D games) and SceneKit (made for 3D games) API's rest on top of Metal. This appl will incorporate SceneKit with ARKit.

//MARK: - Note 2 B.: Look around this template and you'll see things that are slightly differet from what we're used to. First, take a look at art.scnassets folder. Inside here you can see a ship.scn (a starter file) and texture.png (texture map for the ship.scn file) file. If you look at the Material Inspector (shiny circle icon) you can see the diffuse implements the texture map; basically the amount and color that's reflected of the material surface (its the base color or material for the object). In this folder, you'll store all your 3D graphics. Glance inside ViewController file, you can see the imported SceneKit and ARKit modules to leverage the code thats inside and use these frameworks that Apple has created so we can create augmented reality effects really easily without writing a whole bunch of code. In the Main.storyboard, Apple has already implemented a ARSCNView. Searching in the object library you'll get the options: ARKit SceneKit View, ARKit SpritKit View. Basically a view where you can display their respective content using AR. This is linked up to the 'IBOutlet var sceneView: ARSCNView!'. Looking back to the ViewController you can see all the free code Apple has injected. Here the 'sceneView.delegate = self', the current ViewController, and this ViewController also conforms to the ARSCNViewDelegate with its methods below like 'func session', 'func sessionWasInterrupted', and 'func sessionInterruptionEnded'. We don't need these methods at this time so it can be removed. Move to the 'viewDidLoad()' and 'sceneView.showStatistics = true' can be removed, this shows us fps and timing information. Now the 'let scene = SCNScene(named: "art.scnassets/ship.scn")' creates a new scene of the ship we saw in the 'ship.scn' file (directory is in the object). Look over to 'viewWillAppear', just before the view shows up on screen, we're creating a configuration of the type ARWorldTrackingSessionConfiguration, 'let configuration = ARWorldTrackingSessionConfiguration()'. This is where you need an A9 chip or higher to get AR working properly; this is the reason for it. 'ARWorldTrackingSessionConfiguration' is immersive AR where it keeps items fixed in the real world and you can move around it. 'ARSessionConfiguration' when you move the device the virtual object will move with it. ARKit is resource intensive. To see if device can support either of these sessions you can use a property '.isSupported' to check its bool value: 'print("ARSession is supported. \(ARSessionConfiguration.isSupported")', print("AR World Tracking is supported \(ARWorldTrackingSessionConfiguration.isSupported")'. Now you can run the device and see if they're supported. To use this in an actual product, put in a check to see if its supported in 'viewWillAppear' and wrap its contents in: 'if ARWorldTrackingSessionConfiguration.isSupported { let configuration... and sceneView.session.run(configuration) } else { let configuration = ARSessionConfiguration() }' and tell the user that immersive is not supported on their device.

//MARK: - Note 4 A: FInd and import 3D models for AR. You can use Blender! For this project, import a 3D graphic that someone has created in Blender. Blender is an open-source software that can create 3D assets. If you dont have the artistic talent to create these models then, go to www.turbosquid.com. They have a huge catalog of free and paid content; search an asset with a .dae file format (something that is compatable with sceneKit.scn file and can be converted to an SCN file.). Create a free account and download the content. Look for the searched name and Collada.zip file. Inside the downloaded zip file you'll see many files but the ones to incorperate into your app file is the .dae file and any other of the other, essentially, color material(s) you want to use, in this case 'New_RedBase_color.png'. Drag both into art.scnasset folder. At first, when you click the file to view, it might not show anything but if you open the documents inspecter at the lower left and change the view to the front camera you can see that you've got a dice. The dice will be a dull white color and we want to use the 'New_RedBase_Color.png'. So, update the diffuse property inside the interface builder, click on the dropdown list and chose the RedBase color. If you want to compare the size of a 3D asset, you can copy and paste the default 'shipMesh.' file and paste it inside the diceCollada.dae as an additional node under Dice. Now you can see size difference. The bounding box is in meters and the scale is a percentage of that. To convert a 'dae' to 'scn' file, go to Editor dropdown, Convert to SceneKit scene file format (.scn). Refer to Note 4 B.


//MARK: - Note 11: Refactoring for better readability. 
