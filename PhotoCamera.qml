import QtQuick 2.4
import Material 0.1
import QtMultimedia 5.4

Page {
    id: page
    title: "Tomar Foto"

    property ListModel photos: ListModel{}
    property var photosList: []

    Camera{
        id:camera

        imageCapture {
            onImageSaved: {
                page.photosList.push(path);
                photos.append({img:path})
            }
        }
    }
    VideoOutput {
        id: viewfinder
        visible: camera.cameraStatus == Camera.ActiveStatus
        source: camera
        autoOrientation: true
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Rectangle{
        width: parent.width
        height: Units.dp(80)
        anchors.bottom: parent.bottom
        color: Theme.backgroundColor
        IconButton{
            size: Units.dp(80)
            iconName: "image/camera"
            anchors.centerIn: parent
            onClicked: camera.imageCapture.capture()
        }
    }

    function clear(){
        page.photos.clear()
        page.photosList = []
    }
}

