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
    property int num: -1

    text: {
        var c = [ "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" ];
	var retstr = ""
	while (num > 0) {
            retstr = c[num%10] + retstr;
	    num /= 10;
	}
	return retstr
    }

    font.pixelSize: Math.min(width, height)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
