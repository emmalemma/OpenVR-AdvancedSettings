import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import ovras.advsettings 1.0
import "../../common"

GroupBox {
    id: spaceTurnGroupBox
    Layout.fillWidth: true

    label: MyText {
        leftPadding: 10
        text: "Space Turn (anti-comfort mode)"
        bottomPadding: -12
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
            Layout.bottomMargin: 3
        }

        RowLayout {
            Layout.fillWidth: true

            MyToggleButton {
                id: turnBindLeft
                text: "Left Hand"
                onCheckedChanged: {
                    MoveCenterTabController.turnBindLeft = this.checked
                }
            }

            MyToggleButton {
                id: turnBindRight
                text: "Right Hand"
                onCheckedChanged: {
                    MoveCenterTabController.turnBindRight = this.checked
                }
            }

            Item {
                Layout.fillWidth: true
            }

            MyText {
                text: "Comfort Mode:"
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MySlider {
                id: turnComfortSlider
                from: 0
                to: 10
                stepSize: 1
                value: 0
                Layout.preferredWidth: 180
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                onValueChanged: {
                    turnComfortText.text = turnComfortSlider.value
                    MoveCenterTabController.turnComfortFactor = turnComfortSlider.value
                }
            }

            MyText {
                id: turnComfortText
                text: "0"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 30
                Layout.rightMargin: 10
            }

            MyToggleButton {
                id: turnBounds
                text: "Force Bounds"
                onCheckedChanged: {
                    MoveCenterTabController.turnBounds = this.checked
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            MyText {
                text: "Smoothing:"
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MySlider {
                id: turnSlerpSlider
                from: 0.9
                to: 1
                stepSize: 0.001
                value: 0.95
                Layout.preferredWidth: 250
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                onValueChanged: {
                    turnSlerpText.text = turnSlerpSlider.value.toFixed(3)
                    MoveCenterTabController.turnSlerp = turnSlerpSlider.value
                }
            }

            MyText {
                id: turnSlerpText
                text: "0"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 60
                Layout.rightMargin: 10
            }

            MyText {
                text: "Deadzone (deg):"
                horizontalAlignment: Text.AlignRight
                Layout.rightMargin: 10
            }

            MySlider {
                id: turnDeadzoneSlider
                from: 0
                to: 15
                stepSize: 0.01
                value: 5
                Layout.preferredWidth: 250
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                onValueChanged: {
                    turnDeadzoneText.text = turnDeadzoneSlider.value.toFixed(2)
                    MoveCenterTabController.turnDeadzone = turnDeadzoneSlider.value
                }
            }

            MyText {
                id: turnDeadzoneText
                text: "0"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 60
                Layout.rightMargin: 10
            }
        }
    }

    Component.onCompleted: {
        turnBindLeft.checked = MoveCenterTabController.turnBindLeft
        turnBindRight.checked = MoveCenterTabController.turnBindRight
        turnComfortSlider.value = MoveCenterTabController.turnComfortFactor
        turnSlerpSlider.value = MoveCenterTabController.turnSlerp
        turnDeadzoneSlider.value = MoveCenterTabController.turnDeadzone
        turnBounds.checked = MoveCenterTabController.turnBounds
    }

    Connections {
        target: MoveCenterTabController

        onTurnBindLeftChanged: {
            turnBindLeft.checked = MoveCenterTabController.turnBindLeft
        }
        onTurnBindRightChanged: {
            turnBindRight.checked = MoveCenterTabController.turnBindRight
        }
        onTurnComfortFactorChanged: {
            turnComfortSlider.value = MoveCenterTabController.turnComfortFactor
        }
        onTurnSlerpChanged: {
            turnSlerpSlider.value = MoveCenterTabController.turnSlerp
        }
        onTurnDeadzoneChanged: {
            turnDeadzoneSlider.value = MoveCenterTabController.turnDeadzone
        }
        onTurnBoundsChanged: {
            turnBounds.checked = MoveCenterTabController.turnBounds
        }
    }
}
