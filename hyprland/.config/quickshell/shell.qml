// quickshell/shell.qml

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clockWindow
            property var modelData: modelData
            screen: modelData

            // Available height per row: screen height minus top/bottom margins and two row gaps
            readonly property int rowMaxHeight: Math.floor((modelData.height - 32 - 24 - 16) / 3)
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                top: 32
                left: 24
                right: 24
                bottom: 24
            }

            ColumnLayout {
                spacing: 8
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 24
                    rightMargin: 24
                }

                // Row 1: Calendar, Email, Today's Events
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    CalendarWidget {}

                    EmailWidget {
                        model: DataManager.emailModel
                    }

                    TodayCalWidget {
                        model: DataManager.calModel
                        Layout.maximumWidth: (clockWindow.modelData.height / 3)
                    }
                }

                // Row 2: Tasks, Jira
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    TodoWidget {
                        model: DataManager.todoModel
                        status: DataManager.todoStatus
                    }

                    JiraWidget {
                        model: DataManager.jiraModel
                        status: DataManager.jiraStatus
                        maxHeight: clockWindow.rowMaxHeight
                    }
                }

                // Row 3: World Clocks, Forex, Server Status
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    WorldClocksWidget {}

                    ForexWidget {
                        rate: DataManager.forexRate
                        change: DataManager.forexChange
                        changeDir: DataManager.forexChangeDir
                        status: DataManager.forexStatus
                    }

                    ServerWidget {
                        model: DataManager.serverModel
                    }
                }
            }
        }
    }
}
