import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1280
    height: 720
    color: "#081426"

    property int sessionIndex: session.index

    Connections {
        target: sddm

        function onLoginSucceeded() {
            message.text = "Login successful"
            message.color = "#8bd5ff"
        }

        function onLoginFailed() {
            password.text = ""
            message.text = "Login failed. Check your credentials."
            message.color = "#ff8f9b"
        }

        function onInformationMessage(text) {
            message.text = text
            message.color = "#ffcf8a"
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#102b50" }
            GradientStop { position: 0.55; color: "#081426" }
            GradientStop { position: 1.0; color: "#050b16" }
        }
    }

    Rectangle {
        width: Math.min(parent.width - 40, 440)
        height: cardColumn.implicitHeight + 64
        anchors.centerIn: parent
        radius: 18
        color: "#e8111d31"
        border.color: "#426da8"
        border.width: 1

        Column {
            id: cardColumn
            anchors.fill: parent
            anchors.margins: 32
            spacing: 15

            Text {
                text: "ARUNA"
                color: "#eaf4ff"
                font.pixelSize: 30
                font.bold: true
                font.letterSpacing: 5
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Welcome back"
                color: "#9dbbe0"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Username"
                color: "#d8e8fb"
                font.pixelSize: 12
            }

            TextBox {
                id: name
                width: parent.width
                height: 42
                text: userModel.lastUser
                font.pixelSize: 14
                KeyNavigation.tab: password
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            Text {
                text: "Password"
                color: "#d8e8fb"
                font.pixelSize: 12
            }

            PasswordBox {
                id: password
                width: parent.width
                height: 42
                font.pixelSize: 14
                KeyNavigation.backtab: name
                KeyNavigation.tab: session
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            Text {
                text: "Session"
                color: "#d8e8fb"
                font.pixelSize: 12
            }

            ComboBox {
                id: session
                width: parent.width
                height: 40
                model: sessionModel
                index: sessionModel.lastIndex
                font.pixelSize: 14
                KeyNavigation.backtab: password
                KeyNavigation.tab: loginButton
            }

            Text {
                id: message
                width: parent.width
                text: "Select your session and sign in"
                color: "#9dbbe0"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                id: loginButton
                width: parent.width
                height: 42
                text: "Sign in"
                onClicked: sddm.login(name.text, password.text, sessionIndex)
                KeyNavigation.backtab: session
                KeyNavigation.tab: rebootButton
            }

            Row {
                width: parent.width
                spacing: 12

                Button {
                    id: rebootButton
                    width: (parent.width - 12) / 2
                    height: 38
                    text: "Restart"
                    onClicked: sddm.reboot()
                }

                Button {
                    width: (parent.width - 12) / 2
                    height: 38
                    text: "Shut down"
                    onClicked: sddm.powerOff()
                }
            }

            Text {
                text: "Aruna Linux"
                color: "#6f91bb"
                font.pixelSize: 11
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        text: Qt.formatDateTime(new Date(), "ddd, dd MMM yyyy  hh:mm")
        color: "#9dbbe0"
        font.pixelSize: 12
    }
}
