// Copyright (c) 2018 Ultimaker B.V.
// Uranium is released under the terms of the LGPLv3 or higher.

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import UM 1.3 as UM
/**
 * This is a workaround for lacking API in the QtQuick Controls MenuBar.
 * It replicates some of the functionality included in QtQuick Controls'
 * ApplicationWindow class to make the menu bar actually work.
 */
Rectangle
{
    id: menuBackground;

    property QtObject window;
    Binding
    {
        target: menu.__contentItem
        property: "width"
        value: window.width
        when: !menu.__isNative
    }

    default property alias menus: menu.menus

    width: menu.__isNative ? 0 : menu.__contentItem.width
    height: menu.__isNative ? 0 : menu.__contentItem.height

    color: palette.window;

    Keys.forwardTo: menu.__contentItem;

    MenuBar
    {
        id: menu

        Component.onCompleted:
        {
            __contentItem.parent = menuBackground;
        }

        style: MenuBarStyle {
            itemDelegate: Rectangle {
                function replaceText(txt) {
                    var index = txt.indexOf("&");
                    if(index >= 0)
                    txt = txt.replace(txt.substr(index, 2), ("<u>" + txt.substr(index + 1, 1) +"</u>"));
                    return txt;
                }                
                implicitWidth: lab.contentWidth * 1.4
                implicitHeight: lab.contentHeight
                color: styleData.selected || styleData.open ? "#202D35" : "transparent"
                Label {
                    id: lab
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: styleData.selected || styleData.open ? "white" : "black"
                    font: UM.Theme.getFont("default")
                    text: replaceText(styleData.text)
                }
            }
        }
    }



    SystemPalette
    {
        id: palette
        colorGroup: SystemPalette.Active
    }
}
