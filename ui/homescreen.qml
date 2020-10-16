import QtQuick.Layouts 1.3
import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft
import "delegates" as Delegates

Mycroft.Delegate {
    id: root
    property var skillLauncherList: sessionData.skillLauncher
    readonly property int reservedSpaceForLabel: metrics.height
    property bool horizontalMode: root.width > root.height ? 1 : 0
    property bool nonFHD: root.width <= 380 ? 1 : 0
    property var wallpaperSetPath: sessionData.wallpaper_path
    fillWidth: true
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    
    onSkillLauncherListChanged: {
        console.log(skillLauncherList)
    }
    
    onWallpaperSetPathChanged: {
        if(wallpaperSetPath) {
            rootbg.source = Qt.resolvedUrl(wallpaperSetPath)
        }
    }
    
    background: Image {
        id: rootbg
        source: Qt.resolvedUrl("img/seaside.jpg")
        anchors.fill: parent
        cache: false
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
    }

    Label {
        id: metrics
        text: "TexT"
        visible: false
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.9
    }

    Gradient {
	id: gradientVertical
	GradientStop { position: 0.0; color: "#313131" }
	GradientStop { position: 0.5; color: Qt.rgba(0, 0, 0, 0.5) }
	GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
    }
    
    Gradient {
	id: gradientHorizontal
	GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
     }
  
    
    GridLayout {
        id: layoutGrid
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        columns: root.horizontalMode ? 2 : 1
        rows: 1

        Rectangle {
            id: clockArea
            Layout.fillWidth: root.horizontalMode ? 0 : 1
            Layout.preferredWidth: root.horizontalMode ? dtLayout.childrenRect.width + Kirigami.Units.gridUnit * 2 : parent.width
            Layout.preferredHeight: root.horizontalMode ? parent.height : parent.height / 6
            Layout.alignment: root.horizontalMode ? Qt.AlignVCenter | Qt.AlignHCenter : Qt.AlignTop | Qt.AlignHCenter
            Layout.margins: root.horizontalModel ? Kirigami.Units.largeSpacing : -Kirigami.Units.largeSpacing     
	    z: 10
	    gradient: root.horizontalMode ? gradientHorizontal : gradientVertical

            GridLayout {
                id: dtLayout
                height: childrenRect.implicitHeight
                anchors.top: root.horizontalMode ? undefined : parent.top
                anchors.verticalCenter: root.horizontalMode ? parent.verticalCenter : undefined
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Kirigami.Units.largeSpacing * 2
                columns: root.horizontalMode ? 1 : 2
                rows: 1

                DateTimeLabel {
                    id: time
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.leftMargin: Kirigami.Units.largeSpacing
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.Bold
                    font.pixelSize: root.nonFHD ? Kirigami.Units.gridUnit * 1.5 : Kirigami.Units.gridUnit * 3
                    text: sessionData.time_string.replace(":", "꞉")
                }

                ColumnLayout {
                    id: wmLayout
                    Layout.fillHeight: root.horizontalMode ? 1 : 0
                    Layout.alignment: root.horizontalMode ? Qt.AlignLeft | Qt.AlignBottom : Qt.AlignVCenter | Qt.AlignRight
                    Layout.rightMargin: root.width < 600 ? Kirigami.Units.largeSpacing : 0
                    Layout.leftMargin: root.horizontalMode ? Kirigami.Units.largeSpacing : 0
                    
                    DateTimeLabel {
                        id: weekday
                        Layout.alignment: root.horizontalMode ? Qt.AlignLeft | Qt.AlignBottom : Qt.AlignVCenter | Qt.AlignRight
                        font.pixelSize: root.nonFHD ? Kirigami.Units.gridUnit * 0.5 : Kirigami.Units.gridUnit * 1
                        verticalAlignment: Text.AlignTop
                        text: sessionData.weekday_string
                    }

                    DateTimeLabel {
                        id: date
                        Layout.alignment: root.horizontalMode ? Qt.AlignLeft | Qt.AlignBottom : Qt.AlignVCenter | Qt.AlignRight
                        font.pixelSize: root.nonFHD ? Kirigami.Units.gridUnit * 0.5 : Kirigami.Units.gridUnit * 1
                        verticalAlignment: Text.AlignTop
                        text: sessionData.month_string
                    }
                }
            }
        }
        
        //Item {
            //id: spacer
            //Layout.fillWidth: true
            //Layout.preferredHeight: clockArea.height / 2
            //visible: !root.horizontalMode
            //enabled: !root.horizontalMode
        //}
        
        Item {
            id: applicationArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            
            GridView {
                id: appLauncherView
                model: skillLauncherList.skillList
                clip: false
                snapMode: GridView.SnapToRow
                width: parent.width
                height: parent.height
		z: 1
		cacheBuffer: clockArea.height + Kirigami.Units.gridUnit
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: root.horizontalMode ? parent.verticalCenter : 0
                cellWidth: parent.width / 4
                cellHeight: root.horizontalMode ? parent.height / 2 : parent.height / 3
                delegate: Delegates.AppDelegate {
                    metricHeight: metrics.contentHeight
                }
            }
        }
    }
}
