###############################################################################
#   You can use, redistribute, or modify this software under the terms of the
#   GNU General Public License as published by the Free Software Foundation,
#   either version 3 of the License, or any later version.
#   You should have received a copy of the
#   GNU General Public License along with this program.
#   If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# © 2012; Nathan Johnson  ↄ⃝

# For adding optional parameters
Include(CheckCXXCompilerFlag)
Function(AddSupportedCXX)
#Message ( STATUS "# Parameters: " ${ARGC} )
	ForEach( P IN LISTS ARGV )
		Check_CXX_Compiler_Flag ( ${P} Supported )
		If ( Supported )
			Add_Definitions( ${P} )
#		Else()
#Message ( STATUS "Compile parameter not supported ❯"${P}"❮")
		EndIf()
		Unset ( Supported CACHE )
	EndForEach()
EndFunction(AddSupportedCXX)
