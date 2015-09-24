import QtQuick 2.4
import Material 0.1

Page {
    id: page
    title: "Agregar Fotos"
    visible: false

    property alias photos: capturer.photosList

    actions: [
        Action{
            iconName: "action/delete"
            onTriggered: {
                capturer.clear()
            }
        }

    ]

    Flickable{
        id: flick
        anchors.fill: parent
        contentHeight: content.implicitHeight
        Grid{
            id: content
            anchors.fill: parent
            columns: 3
            Repeater{
                model: capturer.photos
                delegate: Item{
                    width: page.width/3
                    height: width
                    Image {
                        anchors.fill: parent
                        sourceSize.height: parent.height
                        sourceSize.width: parent.width
                        source: "file://" + img
                        fillMode: Image.PreserveAspectCrop
                    }
                    Ink{
                        anchors.fill: parent
                        onClicked: {
                            overlay.source = "file://" + img
                            overlayView.open(parent)
                        }
                    }
                }
            }
        }
    }
    OverlayView{
        id: overlayView
        width: root.width - Units.dp(40)
        height: root.height - Units.dp(40)
        Image {
            id: overlay
            anchors.fill: parent
            //source: "images/p23.jpg"
            fillMode: "PreserveAspectCrop"
        }
        IconButton{
            onClicked: overlayView.close()
            iconName: "navigation/close"
            anchors.top: parent.top
            anchors.right: parent.right
        }
        ProgressCircle {
            anchors.centerIn: parent
            visible: overlay.status == Image.Loading
        }
    }

    ActionButton{
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Units.dp(32)
        }
        iconName: "image/camera_alt"
        onClicked: {
            pageStack.push(capturer)
        }
    }
    PhotoCamera{
        id: capturer
    }
}

