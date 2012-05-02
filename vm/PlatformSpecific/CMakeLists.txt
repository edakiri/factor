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

Set ( BootStrapImage "boot" ) # start of name

If ( UNIX ) # including Apple OS X and CygWin
	Set ( BootStrapImage ${BootStrapImage}.unix )
	List ( APPEND SystemLibraries dl pthread )
	Set ( SystemLibraries ${SystemLibraries} PARENT_SCOPE )
	List ( APPEND PlatformLibrary os-unix.cpp  )
	If ( APPLE )
		List ( APPEND PlatformLibrary os-macosx.cpp mach_signal.cpp mvm-unix.cpp )
#-framework Cocoa -L/opt/local/lib $(X11_UI_LIBS) -Wl,-dylib_file,/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
	ElseIf ( ${CMAKE_SYSTEM_NAME} MATCHES "Linux" )
# Set Factor sources for platform
		List ( APPEND PlatformLibrary os-linux.cpp os-genunix.cpp mvm-unix.cpp )
		List ( APPEND PlatformExecutable main-unix.cpp )
	EndIf()
ElseIf ( WINDOWS ) #untested whether valid
	Set ( BootStrapImage ${BootStrapImage}.windows )
Else ()
	Messsage ( FATAL_ERROR "Target OS is not supported." )
EndIf()

# What processor type?
# Are we x86 or AMD64?
Include ( CheckSymbolExists )
Check_Symbol_Exists ( i386 "" Q-Processor )
# on MS Windows, it's _M_IX86 or _M_X64
Message ( STATUS "Is it i386 ?" )
If ( Q-Processor )
	Set ( Processor-x86 1 )
	Message ( STATUS "Yes = ${Processor-x86}")
Else ()
	Unset ( Q-Processor CACHE )
	Check_Symbol_Exists ( __x86_64 "" Q-Processor )
Message ( STATUS "Is it __x86_64 ?" )
If ( Q-Processor )
Message ( STATUS "Yes.")
	Set ( Processor-x86 1 )
	Set ( Bits64 1 ) # ?Temporary? circumvention of compiler nastiness
Else()
	Unset ( Q-Processor CACHE )
	Check_Symbol_Exists ( _M_IX86 "" Q-Processor )
Message ( STATUS "Is it _M_IX86 ?" )
If ( Q-Processor )
Message ( STATUS "Yes.")
# on MS Windows, it's _M_IX86 or _M_X64
	Set ( Processor-x86 1 )
Else()
	Unset ( Q-Processor CACHE )
	Check_Symbol_Exists ( _M_X64 "" Q-Processor )
Message ( STATUS "Is it _M_X64 ?" )
If ( Q-Processor )
Message ( STATUS "Yes.")
	Set ( Processor-x86 1 )
	Set ( Bits64 1 ) # ?Temporary? circumvention of compiler nastiness
Else()
	Unset ( Q-Processor CACHE )
	Check_Symbol_Exists ( __ARMEL__ "" Q-Processor ) # otherwise __arm__
Message ( STATUS "Is it __ARMEL__ ?" )
If ( Q-Processor )
Message ( STATUS "Yes.")
	Set ( Processor-ARM 1 )
Else()
	Message ( FATAL_ERROR "Unhandled processor type." )
EndIf()
EndIf()
EndIf()
EndIf()
EndIf()
Unset ( Q-Processor )
# End processor type check

# ToDo: set CPACK_DEBIAN_PACKAGE_ARCHITECTURE

If ( Processor-x86 )
	List ( APPEND PlatformLibrary cpu-x86.cpp )
	Set ( BootStrapImage ${BootStrapImage}-x86 )
ElseIf ( Processor-ARM )
	List ( APPEND PlatformLibrary os-linux-arm.cpp )
EndIf()

#Enable_Language ( C ) # Needed by CheckTypeSize
#Include(CheckTypeSize)
#Check_Type_Size("void*" WordToYourMotherboard BUILTIN_TYPES_ONLY)
#Message ( STATUS "Processor word size is ${WordToYourMotherboard} bytes wide." )
#If ( WordToYourMotherboard EQUAL 4 )
	#Message ( STATUS "Processor word size is 32 bits wide." )
#ElseIf ( WordToYourMotherboard EQUAL 8 )
	#Message ( STATUS "Processor word size is 64 bits wide." )
	#Set ( Bits64 1 )
#Else ()
#Message ( FATAL_ERROR "Big mama! Word size of "${WordToYourMotherboard}" is not supported." )
#EndIf()

If ( Bits64 )
	Set ( BootStrapImage ${BootStrapImage}.64 )
Else ()
	Set ( BootStrapImage ${BootStrapImage}.32 )
EndIf ()

Include_Directories ( .. )
Add_Library ( PlatformExecutable STATIC ${PlatformExecutable} )
Add_Library ( PlatformLibrary STATIC  ${PlatformLibrary} )
# According to 1 claim, libm is integrated into libc on some platforms, in which case, the succeeding process is needed:
# find_library(m)

Set ( BootStrapImage ${BootStrapImage}.image )
Set ( BootStrapImage ${BootStrapImage} PARENT_SCOPE )
