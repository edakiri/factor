###############################################################################
#   You can use, redistribute, or modify this software under the terms of the
#   GNU General Public License as published by the Free Software Foundation,
#   either version 3 of the License, or any later version.
#   You should have received a copy of the
#   GNU General Public License along with this program.
#   If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# © 2012; Nathan Johnson  ↄ⃝

If ( EXISTS ${BootStrapImage} )
	Message ( FATAL_ERROR "Boot strap image ❬${BootStrapImage}❭ already exists. " )
Else ()
	File ( DOWNLOAD http://downloads.factorcode.org/images/latest/${BootStrapImage} ${CMAKE_BINARY_DIR}/${BootStrapImage}
	SHOW_PROGRESS )
EndIf ()
