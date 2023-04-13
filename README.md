# ExportARFaceGeometry

ExportARFaceGeometry is a simple ARKit app that allows you to export the default `ARFaceGeometry` as a Wavefront .obj file to the app's Documents directory. This can be useful for further development.

## Usage

1. Open the app
2. Point the camera at your face to track your facial geometry
3. Once your facial geometry is tracked, the app will automatically export the `ARFaceGeometry` as a .obj file to the app's Documents directory
4. Connect your device to your computer and open iTunes or Finder to access the Documents directory and retrieve the exported .obj file

Note: This app only exports the default `ARFaceGeometry` without any modifications or deformations.

## Requirements

- iOS device with TrueDepth camera
- Xcode 12+
- Swift 5.3+
- ARKit 4+
