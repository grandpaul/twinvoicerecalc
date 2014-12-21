//  Taiwan invoice reverse calculator
//  Copyright (C) 2014 Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.2
import QtQuick.Window 2.1
import "./qml"

Window {
    visible: true
    width: 800
    height: 500

    TaiwanInvoiceReverseCalculator {
        anchors.fill: parent
        forwardMode: false
    }

}
