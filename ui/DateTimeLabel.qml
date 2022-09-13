import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0

Label {
    font.capitalization: Font.AllUppercase
    font.family: "Noto Sans Display"
    color: "white"
    clip: false    
    layer.enabled: false
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8.0
        samples: 16
        cached: true
        color: Qt.rgba(0, 0, 0, 1)
    }
}
