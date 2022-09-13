import QtQuick.Layouts 1.3
import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft

Item {
    readonly property GridView gridView: GridView.view
    property var metricHeight
    implicitWidth: gridView.cellWidth
    implicitHeight: gridView.cellHeight

    ItemDelegate {
        implicitWidth: parent.width - Kirigami.Units.smallSpacing
        implicitHeight: parent.height - Kirigami.Units.largeSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        background: Rectangle {
            color: "transparent"
        }

        contentItem: ColumnLayout {
            spacing: 0
            
            Image {
                id: iconItem
                Layout.minimumWidth: parent.width
                Layout.minimumHeight: parent.height - metricHeight * 2
                Layout.preferredHeight: Layout.minimumHeight
                Layout.preferredWidth: Layout.minimumWidth
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                fillMode: Image.PreserveAspectFit 
                source: modelData.skillIconPath
                Behavior on scale {
                    NumberAnimation {
                        duration: units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }

            Label {
                id: labelgridView
                visible: text.length > 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: metricHeight * 2.5
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
                Layout.alignment: Qt.AlignTop
                maximumLineCount: 2
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.9
                elide: Text.ElideRight
                color: "white"
                text: modelData.skillDisplayName
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 8.0
                    samples: 16
                    cached: true
                    color: Qt.rgba(0, 0, 0, 1)
                }
                
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }
        }

        onClicked: {
            Mycroft.MycroftController.sendRequest(modelData.skillHandler, {})
        }
    }
}
