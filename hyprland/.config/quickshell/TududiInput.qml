import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    visible: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: root.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    readonly property string scriptPath: Qt.resolvedUrl("scripts/tududi_add.py").toString().replace("file://", "")
    property string statusMsg: ""

    function show() {
        textField.text = ""
        statusMsg = ""
        root.visible = true
        textField.forceActiveFocus()
    }

    function dismiss() {
        root.visible = false
    }

    Process {
        id: addProcess
        stdout: SplitParser {
            onRead: line => {
                if (line.startsWith("OK|||")) {
                    root.statusMsg = "✓ " + line.slice(5)
                    closeTimer.start()
                } else if (line.startsWith("ERROR|||")) {
                    root.statusMsg = "Error: " + line.slice(8)
                }
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 1200
        onTriggered: root.dismiss()
    }

    // dismiss on backdrop click
    MouseArea {
        anchors.fill: parent
        onClicked: root.dismiss()
    }

    Item {
        anchors.centerIn: parent
        width: 480
        height: inner.implicitHeight + 32

        // eat clicks so backdrop MouseArea doesn't fire on the box itself
        MouseArea { anchors.fill: parent }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#1e1e2e"
            border.color: "#cba6f7"
            border.width: 1
        }

        ColumnLayout {
            id: inner
            anchors {
                fill: parent
                margins: 16
            }
            spacing: 10

            Text {
                text: "Add to Tududi inbox"
                color: "#cba6f7"
                font.family: Theme.monoFont
                font.pixelSize: 13
                font.bold: true
            }

            TextField {
                id: textField
                Layout.fillWidth: true
                placeholderText: "What's on your mind?"
                color: Theme.text
                placeholderTextColor: Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 14
                leftPadding: 10
                rightPadding: 10
                topPadding: 8
                bottomPadding: 8

                background: Rectangle {
                    radius: 6
                    color: "#313244"
                    border.color: textField.activeFocus ? "#cba6f7" : "#45475a"
                    border.width: 1
                }

                Keys.onReturnPressed: {
                    const content = text.trim()
                    if (content.length === 0) return
                    addProcess.command = ["python3", root.scriptPath, content]
                    addProcess.running = true
                    root.statusMsg = "Sending…"
                }

                Keys.onEscapePressed: root.dismiss()
            }

            Text {
                Layout.fillWidth: true
                text: root.statusMsg
                color: root.statusMsg.startsWith("Error") ? Theme.red : Theme.green
                font.family: Theme.monoFont
                font.pixelSize: 12
                visible: root.statusMsg.length > 0
                wrapMode: Text.WordWrap
            }
        }
    }
}
