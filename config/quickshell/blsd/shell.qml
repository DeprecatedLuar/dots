import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Shapes

ShellRoot {
    id: root

    FileView {
        id: config
        path: "/tmp/blsd.json"
        watchChanges: true
        onFileChanged: reload()

        adapter: JsonAdapter {
            id: json
            property string color: "#1a1a1a"
            property string color2: "#3a3a3a"
            property real tint: 0.0
            property int borderX: 6
            property int borderY: 3
            property int radius: 12
            property bool visible: true
        }
    }

    PanelWindow {
        id: overlay
        visible: json.visible
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        mask: Region {}

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Item {
            id: frame
            anchors.fill: parent
            property color c: json.color
            property color c2: json.color2

            // Tint layer
            Shape {
                anchors.fill: parent

                ShapePath {
                    strokeWidth: 0
                    strokeColor: "transparent"

                    fillGradient: LinearGradient {
                        x1: 0; y1: 0
                        x2: frame.width; y2: frame.height
                        GradientStop { position: 0.0; color: Qt.rgba(frame.c.r, frame.c.g, frame.c.b, json.tint) }
                        GradientStop { position: 1.0; color: Qt.rgba(frame.c2.r, frame.c2.g, frame.c2.b, json.tint) }
                    }

                    PathRectangle {
                        width: frame.width
                        height: frame.height
                        radius: json.radius
                    }
                }
            }

            // Gradient border using OddEvenFill ring
            Shape {
                anchors.fill: parent
                layer.enabled: true
                layer.samples: 4

                ShapePath {
                    fillRule: ShapePath.OddEvenFill
                    strokeWidth: 0
                    strokeColor: "transparent"

                    fillGradient: LinearGradient {
                        x1: 0; y1: 0
                        x2: frame.width; y2: frame.height
                        GradientStop { position: 0.0; color: frame.c }
                        GradientStop { position: 1.0; color: frame.c2 }
                    }

                    // Outer rounded rect
                    PathRectangle {
                        width: frame.width
                        height: frame.height
                        radius: json.radius
                    }

                    // Inner rounded rect (creates the hole)
                    PathRectangle {
                        x: json.borderX
                        y: json.borderY
                        width: frame.width - json.borderX * 2
                        height: frame.height - json.borderY * 2
                        radius: Math.max(0, json.radius - Math.min(json.borderX, json.borderY))
                    }
                }
            }
        }
    }
}
