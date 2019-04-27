import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4
import "../../base" as Base

Base.HInterfaceBox {
    id: signInBox
    title: "Sign in"

    property string loginWith: "username"

    enterButtonTarget: "login"

    buttonModel: [
        { name: "register", text: qsTr("Register") },
        { name: "login", text: qsTr("Login") },
        { name: "forgot", text: qsTr("Forgot?") }
    ]

    buttonCallbacks: {
        "register": function(button) {},

        "login": function(button) {
            button.loadingUntilFutureDone(
                Backend.clientManager.new(
                    "matrix.org", identifierField.text, passwordField.text
                )
            )
        },

        "forgot": function(button) {}
    }

    Base.HRowLayout {
        spacing: signInBox.margins * 1.25
        Layout.margins: signInBox.margins
        Layout.alignment: Qt.AlignHCenter

        Repeater {
            model: ["username", "email", "phone"]

            Base.HButton {
                iconName: modelData
                circle: true
                checked: loginWith == modelData
                autoExclusive: true
                onClicked: loginWith = modelData
            }
        }
    }

    Base.HTextField {
        id: identifierField
        placeholderText: qsTr(
            loginWith === "email" ? "Email" :
            loginWith === "phone" ? "Phone" :
            "Username"
        )
        onAccepted: signInBox.clickEnterButtonTarget()
        Component.onCompleted: forceActiveFocus()

        Layout.fillWidth: true
        Layout.margins: signInBox.margins
    }

    Base.HTextField {
        id: passwordField
        placeholderText: qsTr("Password")
        echoMode: TextField.Password
        onAccepted: signInBox.clickEnterButtonTarget()

        Layout.fillWidth: true
        Layout.margins: signInBox.margins
    }
}
