import QtQuick 2.4
import Material 0.1
import Material.ListItems 0.1 as ListItem

ApplicationWindow {
    id:root
    title: "Satelites"

    visible: true

    width: Units.dp(426)
    height: Units.dp(640)

    property var post

    theme {
        primaryColor: "#009688"
        primaryDarkColor: "#00796B"
        accentColor: "#8BC34A"
        backgroundColor: "#FFFFFF"
        tabHighlightColor: "#B2DFDB"
    }

    initialPage: Page{
        title: "Geo Localizador"

        backAction: Action{
            iconName: "content/clear"
            onTriggered: Qt.quit()
        }

        View{
            elevation: 2
            anchors.fill: parent
            anchors.topMargin: Units.dp(50)
            anchors.bottomMargin: Units.dp(100)
            anchors.leftMargin: Units.dp(30)
            anchors.rightMargin: Units.dp(30)
            radius: Units.dp(5)
        }

        ActionButton {
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: Units.dp(32)
            }

            iconName: "content/add"
            onClicked: pageStack.push(Qt.resolvedUrl("Reporte.qml"))
        }
    }

    Item{
        id:funcs
        objectName: "funcs"
        signal send(string latitude, string longitude, variant media);
        function set_msj(text){
            pageStack.currentItem.snackBar.open(text)
        }
    }
}
