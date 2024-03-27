#=============================================================================
#  MuseScore
#  Linux Music Score Editor
#
#  Copyright (C) 2023 MuseScore BVBA and others
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#=============================================================================

include(GetBuildType)
include(GetPlatformInfo)
include(version)

if (NOT MUSESCORE_BUILD_CONFIGURATION)
    set(MUSESCORE_BUILD_CONFIGURATION "app")
endif()

if (NOT MUSESCORE_BUILD_MODE)
    set(MUSESCORE_BUILD_MODE "dev")
endif()

# Set revision for local builds
# Before need run 'make revision' or 'msvc_build.bat revision'
include(${CMAKE_CURRENT_LIST_DIR}/build/cmake/TryUseLocalRevision.cmake)

message(STATUS "MUSESCORE_BUILD_CONFIGURATION: ${MUSESCORE_BUILD_CONFIGURATION}")
message(STATUS "MUSESCORE_BUILD_MODE: ${MUSESCORE_BUILD_MODE}")
message(STATUS "MUSESCORE_BUILD_NUMBER: ${CMAKE_BUILD_NUMBER}")

string(TOUPPER ${MUSESCORE_BUILD_CONFIGURATION} BUILD_CONFIGURE)
string(TOUPPER ${MUSESCORE_BUILD_MODE} BUILD_MODE)

###########################################
# Setup by mode
###########################################
if(BUILD_MODE MATCHES "DEV")
    set(MUSESCORE_UNSTABLE ON)
    set(MUSESCORE_RELEASE_CHANNEL "dev")
    set(MUSESCORE_NAME_VERSION "${MUSESCORE_NAME} ${MUSESCORE_VERSION_MAJOR} ${MUSESCORE_RELEASE_CHANNEL}")
    set(MUSESCORE_IS_PRERELEASE ON)
    set(MUSESCORE_ALLOW_UPDATE_ON_PRERELEASE OFF)
endif()

if(BUILD_MODE MATCHES "TESTING")
    set(MUSESCORE_UNSTABLE OFF)
    set(MUSESCORE_RELEASE_CHANNEL "Testing")
    set(MUSESCORE_NAME_VERSION "${MUSESCORE_NAME} ${MUSESCORE_VERSION_MAJOR} ${MUSESCORE_RELEASE_CHANNEL}")
    set(MUSESCORE_IS_PRERELEASE ON)
    set(MUSESCORE_ALLOW_UPDATE_ON_PRERELEASE ON)
endif()

if(BUILD_MODE MATCHES "RELEASE")
    set(MUSESCORE_UNSTABLE OFF)
    set(MUSESCORE_NAME_VERSION "${MUSESCORE_NAME} ${MUSESCORE_VERSION_MAJOR}")
    set(MUSESCORE_IS_PRERELEASE OFF)
    set(MUSESCORE_ALLOW_UPDATE_ON_PRERELEASE OFF)
endif()

###########################################
# Setup paths
###########################################
if (OS_IS_MAC)
    SET(Mscore_INSTALL_NAME  "Contents/Resources/")
    SET(Mscore_SHARE_NAME    "mscore.app/")
elseif (OS_IS_WIN)
    SET(Mscore_INSTALL_NAME  "")
    SET(Mscore_SHARE_NAME    "./")
else()
    SET(Mscore_INSTALL_NAME  "mscore${MUSESCORE_INSTALL_SUFFIX}-${MUSESCORE_VERSION_MAJ_MIN}/")
    SET(Mscore_SHARE_NAME    "share/")
endif()

###########################################
# CONFIGURE: Desktop App
###########################################
set(MUE_GENERAL_APP OFF)
if(BUILD_CONFIGURE MATCHES "APP")
    set(MUE_GENERAL_APP ON)
endif()

if(BUILD_CONFIGURE MATCHES "APP-PORTABLE")
    set(MUE_GENERAL_APP ON)
    set(WIN_PORTABLE ON)
endif()

if (MUE_GENERAL_APP)
    if (BUILD_IS_DEBUG)
        set(MUE_ENABLE_LOGGER_DEBUGLEVEL ON)
    else()
        set(MUE_ENABLE_LOGGER_DEBUGLEVEL OFF)
    endif()
endif()

if (WIN_PORTABLE)
    set(MUE_BUILD_UPDATE_MODULE OFF)
endif()
if (OS_IS_FBSD)
    message(WARNING "Not building unsupported chrashpad client on FreeBSD")
    set(MUE_BUILD_CRASHPAD_CLIENT OFF)
endif()

###########################################
# CONFIGURE: VTest
###########################################
if(BUILD_CONFIGURE MATCHES "VTEST")
    set(MUE_BUILD_UNIT_TESTS OFF)
    set(MUE_ENABLE_LOGGER_DEBUGLEVEL ON)
    set(MUE_BUILD_ASAN ON)

    set(MUE_BUILD_IMAGESEXPORT_MODULE ON)
    set(MUE_BUILD_CONVERTER_MODULE ON)
    set(MUE_BUILD_PROJECT_MODULE ON)
    set(MUE_BUILD_NOTATION_MODULE ON)
    set(MUE_BUILD_UI_MODULE ON)

    set(MUE_BUILD_ACCESSIBILITY_MODULE OFF)
    set(MUE_BUILD_AUDIO_MODULE OFF)
    set(MUE_BUILD_BRAILLE_MODULE OFF)
    set(MUE_BUILD_MIDI_MODULE OFF)
    set(MUE_BUILD_MPE_MODULE OFF)
    set(MUE_BUILD_MUSESAMPLER_MODULE OFF)
    set(MUE_BUILD_NETWORK_MODULE OFF)
    set(MUE_BUILD_SHORTCUTS_MODULE OFF)
    set(MUE_BUILD_VST_MODULE OFF)
    set(MUE_BUILD_APPSHELL_MODULE OFF)
    set(MUE_BUILD_CLOUD_MODULE OFF)
    set(MUE_BUILD_INSPECTOR_MODULE OFF)
    set(MUE_BUILD_INSTRUMENTSSCENE_MODULE OFF)
    set(MUE_BUILD_LANGUAGES_MODULE OFF)
    set(MUE_BUILD_LEARN_MODULE OFF)
    set(MUE_BUILD_MULTIINSTANCES_MODULE OFF)
    set(MUE_BUILD_PALETTE_MODULE OFF)
    set(MUE_BUILD_PLAYBACK_MODULE OFF)
    set(MUE_BUILD_EXTENSIONS_MODULE OFF)
    set(MUE_BUILD_UPDATE_MODULE OFF)
    set(MUE_BUILD_WORKSPACE_MODULE OFF)

    set(MUE_BUILD_IMPORTEXPORT_MODULE OFF)
    set(MUE_BUILD_VIDEOEXPORT_MODULE OFF)

    set(MUE_INSTALL_SOUNDFONT OFF)

    set(MUE_BUILD_CRASHPAD_CLIENT OFF)

endif()

###########################################
# CONFIGURE: UTest
###########################################
if(BUILD_CONFIGURE MATCHES "UTEST")
    set(MUE_BUILD_UNIT_TESTS ON)
    set(MUE_ENABLE_LOGGER_DEBUGLEVEL ON)
    set(MUE_BUILD_AUDIO_MODULE ON)
    set(MUE_BUILD_ASAN ON)

    message(STATUS "If you added tests to a module that didn't have them yet, make sure that this module is enabled, see SetupConfigure.cmake")
    set(MUE_BUILD_MIDI_MODULE OFF)
    set(MUE_BUILD_MUSESAMPLER_MODULE OFF)
    set(MUE_BUILD_NETWORK_MODULE OFF)
    set(MUE_BUILD_SHORTCUTS_MODULE OFF)

    set(MUE_BUILD_APPSHELL_MODULE OFF)
    set(MUE_BUILD_AUTOBOT_MODULE OFF)
    set(MUE_BUILD_CLOUD_MODULE OFF)
    set(MUE_BUILD_CONVERTER_MODULE OFF)
    set(MUE_BUILD_INSPECTOR_MODULE OFF)
    set(MUE_BUILD_INSTRUMENTSSCENE_MODULE OFF)
    set(MUE_BUILD_LANGUAGES_MODULE OFF)
    set(MUE_BUILD_LEARN_MODULE OFF)
    set(MUE_BUILD_MULTIINSTANCES_MODULE OFF)
    set(MUE_BUILD_PALETTE_MODULE OFF)
    set(MUE_BUILD_PLAYBACK_MODULE OFF)
    set(MUE_BUILD_UPDATE_MODULE OFF)
    set(MUE_BUILD_WORKSPACE_MODULE OFF)
endif()

###########################################
# Subsystem
###########################################

set(QT_SUPPORT ON)

if (NOT MUE_BUILD_AUDIO_MODULE)
    set(MUE_BUILD_MUSESAMPLER_MODULE OFF)
    set(MUE_BUILD_VST_MODULE OFF)
endif()

if (MUE_ENABLE_AUDIO_JACK)
    add_definitions(-DJACK_AUDIO)
endif()

if (NOT MUE_BUILD_IMPORTEXPORT_MODULE)
    set(MUE_BUILD_VIDEOEXPORT_MODULE OFF)
endif()

if (NOT MUE_BUILD_DIAGNOSTICS_MODULE)
    set(MUE_BUILD_CRASHPAD_CLIENT OFF)
endif()

if (MUE_BUILD_ASAN)
    set(MUE_ENABLE_CUSTOM_ALLOCATOR OFF)
endif()

if (NOT MUE_BUILD_NOTATION_MODULE)
    set(MUE_BUILD_PROJECT_MODULE OFF) # hard dependency
    set(MUE_BUILD_PALETTE_MODULE OFF) # hard dependency
endif()

if (NOT MUE_BUILD_UI_MODULE)
    set(MUE_BUILD_APPSHELL_MODULE OFF) # hard dependency
endif()

###########################################
# Unit tests
###########################################
if (NOT MUE_BUILD_UNIT_TESTS)

    set(MUE_BUILD_ACCESSIBILITY_TESTS OFF)
    set(MUE_BUILD_AUDIO_TESTS OFF)
    set(MUE_BUILD_DRAW_TESTS OFF)
    set(MUE_BUILD_GLOBAL_TESTS OFF)
    set(MUE_BUILD_MPE_TESTS OFF)
    set(MUE_BUILD_NETWORK_TESTS OFF)
    set(MUE_BUILD_UI_TESTS OFF)

    set(MUE_BUILD_BRAILLE_TESTS OFF)
    set(MUE_BUILD_DIAGNOSTICS_TESTS OFF)
    set(MUE_BUILD_ENGRAVING_TESTS OFF)
    set(MUE_BUILD_IMPORTEXPORT_TESTS OFF)
    set(MUE_BUILD_NOTATION_TESTS OFF)
    set(MUE_BUILD_PLAYBACK_TESTS OFF)
    set(MUE_BUILD_EXTENSIONS_TESTS OFF)
    set(MUE_BUILD_PROJECT_TESTS OFF)
    set(MUE_BUILD_UPDATE_TESTS OFF)

endif()

###########################################
# Global definitions
###########################################
add_definitions(-DMU_APP_NAME="${MUSESCORE_NAME}")
add_definitions(-DMU_APP_REVISION="${MUSESCORE_REVISION}")
add_definitions(-DMU_APP_BUILD_NUMBER="${CMAKE_BUILD_NUMBER}")
add_definitions(-DMU_APP_VERSION="${MUSESCORE_VERSION}")
add_definitions(-DMU_APP_VERSION_LABEL="${MUSESCORE_VERSION_LABEL}")
add_definitions(-DMU_APP_INSTALL_SUFFIX="${MUSESCORE_INSTALL_SUFFIX}")
add_definitions(-DMU_APP_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}")
add_definitions(-DMU_APP_INSTALL_NAME="${Mscore_INSTALL_NAME}")

if (MUSESCORE_UNSTABLE)
    add_definitions(-DMU_APP_UNSTABLE)
endif()

if (MUSESCORE_ALLOW_UPDATE_ON_PRERELEASE)
    add_definitions(-DMUSESCORE_ALLOW_UPDATE_ON_PRERELEASE)
endif()

function(def_opt name val)
    if (${val})
        add_definitions(-D${name})
    endif()
endfunction()

# framework
def_opt(MUE_BUILD_ACCESSIBILITY_MODULE ${MUE_BUILD_ACCESSIBILITY_MODULE})
def_opt(MUE_BUILD_AUDIO_MODULE ${MUE_BUILD_AUDIO_MODULE})
def_opt(MUE_ENABLE_AUDIO_EXPORT ${MUE_ENABLE_AUDIO_EXPORT})
def_opt(MUE_BUILD_MIDI_MODULE ${MUE_BUILD_MIDI_MODULE})
def_opt(MUE_BUILD_MPE_MODULE ${MUE_BUILD_MPE_MODULE})
def_opt(MUE_BUILD_MUSESAMPLER_MODULE ${MUE_BUILD_MUSESAMPLER_MODULE})
def_opt(MUE_BUILD_NETWORK_MODULE ${MUE_BUILD_NETWORK_MODULE})
def_opt(MUE_BUILD_SHORTCUTS_MODULE ${MUE_BUILD_SHORTCUTS_MODULE})
def_opt(MUE_BUILD_UI_MODULE ${MUE_BUILD_UI_MODULE})
def_opt(MUE_BUILD_VST_MODULE ${MUE_BUILD_VST_MODULE})
# modules
def_opt(MUE_BUILD_APPSHELL_MODULE ${MUE_BUILD_APPSHELL_MODULE})
def_opt(MUE_BUILD_AUTOBOT_MODULE ${MUE_BUILD_AUTOBOT_MODULE})
def_opt(MUE_BUILD_BRAILLE_MODULE ${MUE_BUILD_BRAILLE_MODULE})
def_opt(MUE_BUILD_CLOUD_MODULE ${MUE_BUILD_CLOUD_MODULE})
def_opt(MUE_BUILD_CONVERTER_MODULE ${MUE_BUILD_CONVERTER_MODULE})
def_opt(MUE_BUILD_DIAGNOSTICS_MODULE ${MUE_BUILD_DIAGNOSTICS_MODULE})
def_opt(MUE_BUILD_EXTENSIONS_MODULE ${MUE_BUILD_EXTENSIONS_MODULE})
def_opt(MUE_BUILD_INSPECTOR_MODULE ${MUE_BUILD_INSPECTOR_MODULE})
def_opt(MUE_BUILD_INSTRUMENTSSCENE_MODULE ${MUE_BUILD_INSTRUMENTSSCENE_MODULE})
def_opt(MUE_BUILD_LANGUAGES_MODULE ${MUE_BUILD_LANGUAGES_MODULE})
def_opt(MUE_BUILD_LEARN_MODULE ${MUE_BUILD_LEARN_MODULE})
def_opt(MUE_BUILD_MULTIINSTANCES_MODULE ${MUE_BUILD_MULTIINSTANCES_MODULE})
def_opt(MUE_BUILD_NOTATION_MODULE ${MUE_BUILD_NOTATION_MODULE})
def_opt(MUE_BUILD_PALETTE_MODULE ${MUE_BUILD_PALETTE_MODULE})
def_opt(MUE_BUILD_PLAYBACK_MODULE ${MUE_BUILD_PLAYBACK_MODULE})
def_opt(MUE_BUILD_PROJECT_MODULE ${MUE_BUILD_PROJECT_MODULE})
def_opt(MUE_BUILD_UPDATE_MODULE ${MUE_BUILD_UPDATE_MODULE})
def_opt(MUE_BUILD_WORKSPACE_MODULE ${MUE_BUILD_WORKSPACE_MODULE})
def_opt(MUE_BUILD_IMPORTEXPORT_MODULE ${MUE_BUILD_IMPORTEXPORT_MODULE})
def_opt(MUE_BUILD_VIDEOEXPORT_MODULE ${MUE_BUILD_VIDEOEXPORT_MODULE})
def_opt(MUE_BUILD_IMAGESEXPORT_MODULE ${MUE_BUILD_IMAGESEXPORT_MODULE})
def_opt(MUE_BUILD_CRASHPAD_CLIENT ${MUE_BUILD_CRASHPAD_CLIENT})

def_opt(MUE_COMPILE_USE_QTFONTMETRICS ${MUE_COMPILE_USE_QTFONTMETRICS})
def_opt(MU_BUILD_UNIT_TESTS ${MUE_BUILD_UNIT_TESTS})

if (QT_SUPPORT)
    add_definitions(-DQT_SUPPORT)
    add_definitions(-DKORS_LOGGER_QT_SUPPORT)
    add_definitions(-DSCRIPT_INTERFACE)

    if (MUE_COMPILE_QT5_COMPAT)
        add_definitions(-DMU_QT5_COMPAT)
    endif()

else()
    add_definitions(-DNO_QT_SUPPORT)
endif()

if (WIN_PORTABLE)
    add_definitions(-DWIN_PORTABLE)
endif()

add_definitions(-DKORS_PROFILER_ENABLED)

if (MUE_ENABLE_LOAD_QML_FROM_SOURCE)
    add_definitions(-DMUE_ENABLE_LOAD_QML_FROM_SOURCE)
endif()
