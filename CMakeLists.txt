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
Project ( FactorLanguage CXX C )

Set ( FactorBinaryName "factorVM" CACHE STRING "Name of the executable containing the entry point." )
Set ( GUI 1 CACHE BOOL "GUI feature" )

Set ( ${CMAKE_PROJECT_NAME}_VERSION_MAJOR 0 )
Set ( ${CMAKE_PROJECT_NAME}_VERSION_MINOR 95 )
Set ( ${CMAKE_PROJECT_NAME}_VERSION_PATCH 0 )

List ( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" )

Include ( EveryoneIsDoingIt )

Add_SubDirectory ( vm )

Add_Custom_Command ( OUTPUT ${BootStrapImage}
	COMMAND cmake -DBootStrapImage:STRING=${BootStrapImage} -P ${CMAKE_SOURCE_DIR}/CMake/ObtainBootStrapImage.cmake
	)

# Big Deficiency of CMake: If the target on which this command hangs is not defined in the same CMake file, it will silently not be defined
Add_Custom_Command (
	OUTPUT "${FactorBinaryName}.image"
	COMMAND vm/${FactorBinaryName} -resource-path=${CMAKE_SOURCE_DIR} -i=${BootStrapImage} -output-image=${FactorBinaryName}.image
	DEPENDS ${FactorBinaryName} ${BootStrapImage}
	COMMENT "Boot strap the image file for the factor language."
	VERBATIM )

Add_Custom_Target ( image ALL DEPENDS ${FactorBinaryName}.image
	COMMENT "Create the 'image' file used when running. Bootstrap the environment."
	)

Install ( DIRECTORY basis core DESTINATION ${FileDestination} DIRECTORY_PERMISSIONS ${ExecutablePermissions} )
Install ( FILES "${CMAKE_BINARY_DIR}/${FactorBinaryName}.image" DESTINATION ${FileDestination} )

# For Debian
#http://www.debian.org/doc/debian-policy/ch-docs.html#s-copyrightfile
If ( NOT InstallInSingleDirectoryBase )
	Configure_File ( license.txt copyright COPYONLY )
        Install ( FILES "${CMAKE_BINARY_DIR}/copyright" DESTINATION ${CMAKE_INSTALL_DOCDIR} )
EndIf()

Message ( STATUS "Files to be stripped are: ❬${CPACK_STRIP_FILES}❭ ." )

#	CPack (unused)
# For unused package generators
Set ( CPACK_PACKAGE_CONTACT "Factor Language Community <factor-talk@lists.sourceforge.net>" )
Set ( CPACK_PACKAGE_DESCRIPTION_SUMMARY "JIT compiled stack based language." )
# unused? Set ( CPACK_PACKAGE_DESCRIPTION
#Set ( CPACK_PACKAGE_NAME "factorlanguage" ) # file name base
Set ( CPACK_DEBIAN_PACKAGE_DESCRIPTION "JIT compiled stack based language. Concatenative." )
Set ( CPACK_DEBIAN_PACKAGE_DEPENDS "libc6,libstdc++6,libgcc1" )
Set ( CPACK_DEBIAN_PACKAGE_RECOMMENDS "libgtkglext1-dev" ) # needed for GUI

#Include(CPack) # Call Include after set variables
