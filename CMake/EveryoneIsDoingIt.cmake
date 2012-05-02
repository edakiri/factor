###############################################################################
#   You can use, redistribute, or modify this software under the terms of the
#   GNU General Public License as published by the Free Software Foundation,
#   either version 3 of the License, or any later version.
#   You should have received a copy of the
#   GNU General Public License along with this program.
#   If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# © 2012; Nathan Johnson  ↄ⃝

# Things which most projects would use.

Set ( InstallInSingleDirectoryBase 1 CACHE BOOL "Install under everything under a single directory rather than distributed into system directories. For example, /opt/ or /usr/local/opt/ ." )
Set ( InstallInSingleDirectoryBase ${InstallInSingleDirectoryBase} )
Set ( ExecutablePermissions OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE  GROUP_READ WORLD_EXECUTE WORLD_READ CACHE STRING "Permissions for directories and executable files." FORCE )
Set ( ExecutablePermissions ${ExecutablePermissions} )

If ( CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT
	AND InstallInSingleDirectoryBase )
	Set ( CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/opt/${CMAKE_PROJECT_NAME}" CACHE PATH "Base directory for installation" FORCE )
	Set ( CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX} )
EndIf ()
Message ( STATUS "CMAKE_INSTALL_PREFIX = ❬${CMAKE_INSTALL_PREFIX}❭" )

If ( InstallInSingleDirectoryBase )
	Set ( CMAKE_INSTALL_BINDIR "." )
        Set ( CMAKE_INSTALL_LIBDIR "." )
        Set ( FileDestination "." )
	#Set ( CMAKE_SKIP_BUILD_RPATH FALSE )
	#Set ( CMAKE_BUILD_WITH_INSTALL_RPATH TRUE )
	#Set ( CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE )
	Set ( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX} )
Else()
Include ( GNUInstallDirs )
# DIRECTORY_PERMISSIONS for sake of Debian
        Set ( FileDestination "${CMAKE_INSTALL_DATADIR}/${CMAKE_PROJECT_NAME}" )
EndIf()

#CMAKE_BUILD_TYPE is defined before CMakeLists.txt is run
If ( (NOT DEFINED CMAKE_BUILD_TYPE) OR (CMAKE_BUILD_TYPE STREQUAL "") )
	Message ( STATUS "CMAKE_BUILD_TYPE was not set." )
	Set ( CMAKE_BUILD_TYPE DEBUG CACHE STRING
"Build type. One of [DEBUG|RELEASE|RELWITHDEBINFO|MINSIZEREL] or nothing."
		FORCE )
EndIf ()

#	CPack
# version 2.8.7 is not ready for use. Check bugs before using.
# CPack , debug with
# cpack --debug --verbose
# Generator DEB is disfunctional. So are TAr files.
# Check bug tracker before use.
#Set ( CPACK_PROJECT_CONFIG_FILE "CMake/ForCPack.cmake" )
Set ( CPACK_GENERATOR "ZIP" )
Set ( CPACK_SOURCE_GENERATOR "ZIP" )

# To get owner as user root. TAR_OPTIONS does not work with libarchive 3.0.4
Set ( ENV{TAR_OPTIONS} "--numeric-owner --owner=0 --group=0 --mode=go+r-w" )
Set ( CPACK_PACKAGE_VERSION_MAJOR ${${CMAKE_PROJECT_NAME}_VERSION_MAJOR} )
Set ( CPACK_PACKAGE_VERSION_MINOR ${${CMAKE_PROJECT_NAME}_VERSION_MINOR} )
Set ( CPACK_PACKAGE_VERSION_PATCH ${${CMAKE_PROJECT_NAME}_VERSION_PATCH} )
Set ( CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX} )
