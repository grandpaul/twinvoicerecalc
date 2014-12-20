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

import QtQuick 2.0

Text {
    property int digit: -1

    text: {
        var c = [ "零", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖" ];
        if (0 <= digit && digit <= 9) {
	    return c[digit];
	}
	return ""
    }

    font.pixelSize: Math.min(width, height)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
