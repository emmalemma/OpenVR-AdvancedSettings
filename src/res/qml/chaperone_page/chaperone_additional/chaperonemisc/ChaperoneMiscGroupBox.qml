import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../../common"
import "." // QTBUG-34418, singletons require explicit import to load qmldir file
GroupBox {
    id: chaperoneMiscGroupBox
    Layout.fillWidth: true

    label: MyText {
        leftPadding: 10
        text: "Misc:"
        bottomPadding: -10
    }
    background: Rectangle {
        color: "transparent"
        border.color: "#ffffff"
        radius: 8
    }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            color: "#ffffff"
            height: 1
            Layout.fillWidth: true
            Layout.bottomMargin: 5
        }

        RowLayout {
            spacing: 16

            MyToggleButton {
                id: chaperoneFloorToggleBtn
                text: "Floor Bounds Always On"
                Layout.preferredWidth: 375
                onCheckedChanged: {
                    ChaperoneTabController.setChaperoneFloorToggle(this.checked, false)
                }
            }


            MyToggleButton {
                id: legacyCenterMarkerbtn
                text: "Legacy Center Marker"
                Layout.preferredWidth: 375
                onCheckedChanged: {
                    ChaperoneTabController.setCenterMarker(this.checked, false)
                }
            }

            MyPushButton{
                id:btnResetOrientation
                text: "Reset Turn Counter"
                onClicked: {
                    StatisticsTabController.statsRotationResetClicked()
                }
            }

        }

        RowLayout {

            MyText {
                text: "Turn counter alpha:"
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MySlider {
                id: turnCounterAlphaSlider
                from: 0
                to: 1
                stepSize: 0.01
                value: 0.5
                Layout.preferredWidth: 250
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                onValueChanged: {
                    turnCounterAlphaText.text = turnCounterAlphaSlider.value.toFixed(2)
                    ChaperoneTabController.turnCounterAlpha = turnCounterAlphaSlider.value
                }
            }

            MyText {
                id: turnCounterAlphaText
                text: "0"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 60
                Layout.rightMargin: 10
            }
        }

    }

    Component.onCompleted: {
            chaperoneFloorToggleBtn.checked = ChaperoneTabController.chaperoneFloorToggle
            legacyCenterMarkerbtn.checked = ChaperoneTabController.centerMarker
            turnCounterAlphaSlider.value = ChaperoneTabController.turnCounterAlpha
    }

    Connections {
        target: ChaperoneTabController
        onChaperoneFloorToggleChanged:{
            chaperoneFloorToggleBtn.checked = ChaperoneTabController.chaperoneFloorToggle
        }
        onCenterMarkerChanged:{
            legacyCenterMarkerbtn.checked = ChaperoneTabController.centerMarker
        }
        onTurnCounterAlphaChanged:{
            turnCounterAlphaSlider.value = ChaperoneTabController.turnCounterAlpha
        }
    }
}
