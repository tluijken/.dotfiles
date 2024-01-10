/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0
import "Components"

Rectangle {
    id: container
    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.Background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        //visible: primaryScreen

        Clock {
            id: clock
            anchors.margins: 5
            anchors.top: parent.top; anchors.right: parent.right

            color: config.MainColor
            timeFont.family: "Oxygen"
        }

        Rectangle {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(320, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)
            color: "#80282828"
            radius: config.RoundCorners

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    color: config.MainColor
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        font.bold: true
                        color: config.MainColor
                        font.pixelSize: 12
                    }

                    CustomTextBox {
                        id: name
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14
                        color: config.BackgroundColor
                        hoverColor: config.AccentColor
                        borderColor: "Transparent"
                        textColor: config.MainColor
                        focusColor: config.AccentColor
                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        color: config.MainColor
                        font.bold: true
                        font.pixelSize: 12
                    }

                    CustomPasswordBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14
                        color: config.BackgroundColor
                        hoverColor: config.AccentColor
                        borderColor: "Transparent"
                        textColor: config.MainColor
                        focusColor: config.AccentColor

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }


                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: config.MainColor
                        text: textConstants.prompt
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8
                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
                        color: "#458588"
                        onClicked: sddm.login(name.text, password.text, sessionIndex)
                        radius: config.RoundCorners
                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
                        color: "#458588"
                        onClicked: sddm.powerOff()
                        radius: config.RoundCorners
                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
                        color: "#458588"
                        onClicked: sddm.reboot()
                        radius: config.RoundCorners
                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
