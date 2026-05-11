import Quickshell // for PanelWindow
import Quickshell.Io // I/O
import QtQuick // for Text
import QtQuick.Controls


Variants {
  model: Quickshell.screens;

  delegate: Component {

    PanelWindow {

      required property var modelData

      screen: modelData

      anchors {
        top: true
      }

      implicitHeight: 30

      Calendar {
        selectedDate: new Date()
      }
      
    }
  }
}


