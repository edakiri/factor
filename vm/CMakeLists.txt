###############################################################################
#   You can use, redistribute, or modify this software under the terms of the
#   GNU General Public License as published by the Free Software Foundation,
#   either version 3 of the License, or any later version.
#   You should have received a copy of the
#   GNU General Public License along with this program.
#   If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# © 2012; Nathan Johnson  ↄ⃝

CMake_Minimum_Required ( VERSION 2.8 )

# For adding optional parameters
Include(AddSupported)

AddSupportedCXX ( -pipe -fPIC -Wl,--no-undefined -Wl,--no-as-needed -Wl,--export-dynamic )

#	Linker Flags
# Surely this must be changed to account for different linkers.
# Upon asking, no one explained why these are desired – so take them out and see whether it causes problems. (X Consortium approach)
# -Wl,--export-dynamic
Set ( CMAKE_SHARED_LINKER_FLAGS " -Wl,--no-undefined -Wl,--no-as-needed -Wl,--export-dynamic" )
Set ( CMAKE_SHARED_LINKER_FLAGS ${CMAKE_SHARED_LINKER_FLAGS} PARENT_SCOPE )
# If this is not present, at run time, it will not find symbols and give error
# Cannot resolve C library function
# -Wl,--no-as-needed

If ( GUI )
	find_package(PkgConfig) # Load the function
	pkg_check_modules ( Library REQUIRED
gtkglext-1.0 gtk+-2.0 pangox gdk-2.0 gio-2.0 pangoft2 gmodule-2.0 gthread-2.0 glib-2.0 )
	If ( NOT DEFINED Library_LIBRARIES )
		Message ( FATAL_ERROR "GUI development packages missing. On Debian, these are installed by package libgtkglext1-dev." )
	EndIf ()
	List ( APPEND SystemLibraries ${Library_LIBRARIES} )
	List ( SORT SystemLibraries ) # visual duplicate checking
EndIf()

Include_Directories ( . PlatformSpecific )
Aux_Source_Directory ( . SourceFiles )
Add_SubDirectory ( PlatformSpecific )
Set ( BootStrapImage ${BootStrapImage} PARENT_SCOPE )

#Message (FATAL_ERROR "CMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}")
Add_Library ( ${FactorBinaryName}Shared SHARED ${SourceFiles} )
#Get_Property ( TargetPath TARGET ${FactorBinaryName}Shared PROPERTY OUTPUT_NAME )
List ( APPEND CPACK_STRIP_FILES "${FactorBinaryName}Shared" )
Set ( CPACK_STRIP_FILES ${CPACK_STRIP_FILES} PARENT_SCOPE )

Target_Link_Libraries ( ${FactorBinaryName}Shared PlatformLibrary  ${SystemLibraries} m rt )

Add_Executable ( ${FactorBinaryName} main.cpp )

Target_Link_Libraries ( ${FactorBinaryName} PlatformExecutable ${FactorBinaryName}Shared )

Install (TARGETS ${FactorBinaryName} ${FactorBinaryName}Shared
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} PERMISSIONS ${ExecutablePermissions}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} PERMISSIONS ${ExecutablePermissions}
	)
