import QtQuick.Layouts 1.3
import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft

Item {
    readonly property GridView gridView: GridView.view
    implicitWidth: gridView.cellWidth
    implicitHeight: gridView.cellHeight

    ItemDelegate {
        implicitWidth: parent.width - Kirigami.Units.largeSpacing
        implicitHeight: parent.height - Kirigami.Units.largeSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        background: Rectangle {
            color: "transparent"
        }

        contentItem: ColumnLayout {
            Image {
                id: iconItem
                Layout.minimumWidth: parent.width
                Layout.minimumHeight: parent.width
                Layout.preferredHeight: Layout.minimumHeight
                Layout.preferredWidth: Layout.minimumWidth
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                source: modelData.skillIconPath
                Behavior on scale {
                    NumberAnimation {
                        duration: units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            Label {
                id: labelgridView
                visible: text.length > 0
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignTop
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
            }
        }

        onClicked: {
            Mycroft.MycroftController.sendRequest(modelData.skillHandler, {})
        }
    }
}
