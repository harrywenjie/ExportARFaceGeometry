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
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }

        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)
        faceGeometry?.update(from: faceAnchor.geometry)
        
        // Export the geometry as a .obj file
        let objFile = faceAnchor.geometry.toObjFile()
        
        let objFilename = "ARFaceGeometry.obj"
        
        // Save the .obj file to the app's Documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let objURL = documentsDirectory.appendingPathComponent(objFilename)
        
        do {
            try objFile.write(to: objURL, atomically: true, encoding: String.Encoding.utf8)
            print("Successfully saved ARFaceGeometry.obj to the Documents directory")
        } catch {
            print("Error saving ARFaceGeometry.obj: \(error)")
        }
    }
}

func scnVector3(from simdVector: simd_float3) -> SCNVector3 {
    return SCNVector3(simdVector.x, simdVector.y, simdVector.z)
}

extension ARFaceGeometry {
    func toObjFile() -> String {
        var objString = "# Exported ARFaceGeometry OBJ\n\n"
        
        for vertexIndex in 0..<self.vertices.count {
            let vertex = scnVector3(from: self.vertices[vertexIndex])
            objString += "v \(vertex.x) \(vertex.y) \(vertex.z)\n"
        }
        
        for texCoordIndex in 0..<self.textureCoordinates.count {
            let texCoord = self.textureCoordinates[texCoordIndex]
            objString += "vt \(texCoord.x) \(texCoord.y)\n"
        }
        
        for i in stride(from: 0, to: self.triangleIndices.count, by: 3) {
            let indices = [
                Int(self.triangleIndices[i]) + 1,
                Int(self.triangleIndices[i + 1]) + 1,
                Int(self.triangleIndices[i + 2]) + 1
            ]
            objString += "f \(indices[0])/\(indices[0])/\(indices[0]) \(indices[1])/\(indices[1])/\(indices[1]) \(indices[2])/\(indices[2])/\(indices[2])\n"
        }
        return objString
    }
}

extension SCNVector3 {
    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        return SCNVector3(x / length, y / length, z / length)
    }
}
