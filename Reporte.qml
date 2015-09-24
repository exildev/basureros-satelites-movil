import QtQuick 2.4
import QtPositioning 5.3
import Material 0.1
import Material.ListItems 0.1 as ListItem
import exile.server 1.0

Page {

     title: "Reportar Basurero"

     property alias snackBar: snackbar

     Column{
        anchors.fill: parent
        anchors.topMargin: Units.dp(20)
        //spacing: Units.dp(20)

        Label{
            text: "Ubicación"
            style: "title"
            width: parent.width
            horizontalAlignment: "AlignHCenter"
        }
        Label{
            text: gps.position.latitudeValid && gps.position.longitudeValid?'('+gps.position.coordinate.latitude+', '+gps.position.coordinate.longitude+')': "GPS no disponible"
            style: "title"
            width: parent.width
            horizontalAlignment: "AlignHCenter"
        }
        Item{
            width: parent.width
            height: Units.dp(220)
            clip: true

            Rectangle{
                id:borde
                width: parent.width
                height: Units.dp(2)
                color: "transparent"
                anchors.bottom:parent.bottom
                anchors.bottomMargin: Units.dp(20)
                Image {
                    anchors.fill: parent
                    source: "images/linea.svg"
                    fillMode: Image.PreserveAspectCrop
                }
            }
            Icon{
                id: pin
                name: "maps/place"
                size: Units.dp(200)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: borde.top
            }
            Rectangle{
                width: Units.dp(15)
                height: Units.dp(15)
                radius: width/2
                color: Theme.backgroundColor
                border.color: Theme.light.iconColor
                border.width: Units.dp(3)
                anchors.centerIn: borde
            }
            Ink{
                anchors.fill: pin
                circular: true
                onClicked: {
                    gps.update()
                    pinAnim.start()
                    snackbar.open("Actualizando el GPS...")
                }
            }
        }
        Label{
            text: "Fotos de referencia"
            style: "title"

        }
        Item{
            width: parent.width
            height: Units.dp(150)

            Icon{
                id:camera
                name: "image/camera_alt"
                size: Units.dp(100)
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Units.dp(30)
                Ink{
                    anchors.fill: parent
                    circular: true
                    onClicked: {
                        pageStack.push({item:photo, properties: {visible: true}})
                    }
                }
            }
            Icon{
                id: images
                name: "image/image"
                size: Units.dp(100)
                anchors.left: camera.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Units.dp(30)
                Ink{
                    anchors.fill: parent
                    circular: true
                    onClicked: snackbar.open("digan cheese!!")
                }
            }
        }

     }
     ListItem.Standard {
         anchors.bottom: parent.bottom
         content: Button {
             text: "Atras"
             elevation: 1
             anchors.horizontalCenter: parent.horizontalCenter
             onClicked: {
                 //clear()
                 pageStack.pop()
             }
         }
         secondaryItem: Button {
             text: "Enviar"
             elevation: 1
             anchors.horizontalCenter: parent.horizontalCenter
             //enabled: gps.position.latitudeValid && gps.position.longitudeValid
             onClicked: {
                 snackbar.text = "Enviando..."
                 snackbar.opened = true
                 send(""+gps.position.coordinate.latitude, ""+gps.position.coordinate.longitude, photo.photos)
             }
         }
     }

     SequentialAnimation{
         id:pinAnim

         loops: -1
         PropertyAnimation { target: pin; property: "anchors.bottomMargin"; to:Units.dp(100); duration: 200; easing.type: Easing.Linear}
         PropertyAnimation { target: pin; property: "anchors.bottomMargin"; to:Units.dp(0); duration: 500; easing.type: Easing.OutElastic}
     }

     PositionSource{
         id:gps
         onPositionChanged: {
             pinAnim.stop()
             snackbar.open("GPS Actualizado")
         }
     }

     PhotoCollection{
         id:photo
     }

     Snackbar{
         id:snackbar
     }

     WebRequest{
         id: app
         onCompleted: {
             if(status == 200){
                 snackBar.open("Enviado con exito")
             }else{
                 snackBar.open("Error al enviar")
             }
             console.log(status, data)
         }

         onUploadProgress: {
             console.log("subiendo",percent)
         }
         onDownloadProgress: {
             console.log(percent)
         }
     }

     function send(latitude, longitude, photos){
         var inputs = [
                     {name:'latitude', value:"10.3948839"},
                     {name:'longitude', value:"-75.5099748"}
                 ]
         for(var i = 0; i< photos.length; i++){
             inputs.push({name:'image', value:photos[i], isfile:true})
         }
         console.log(inputs.length)
         app.request("http://104.236.113.108:8080/basureros/reportar/", inputs, true, true)
     }
}

