cmake_minimum_required(VERSION 3.16)

project(ClickerTest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick WebSockets)

include(C:/Users/Nick/AppData/Local/Android/Sdk/android_openssl/android_openssl.cmake)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appClickerTest
    main.cpp
)

qt_add_qml_module(appClickerTest
    URI ClickerTest
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES StartPage.qml
        QML_FILES GamePage.qml
        RESOURCES font/futura.otf
)

qt_add_resources(appClickerTest "app_font"
    PREFIX "/"
    FILES
        font/futura.otf
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appClickerTest PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appClickerTest
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appClickerTest PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Quick
    Qt::WebSockets
)

if (ANDROID)
    add_android_openssl_libraries(appClickerTest)
endif()
if (ANDROID)
    include(C:/Users/Nick/AppData/Local/Android/Sdk/android_openssl/CMakeLists.txt)
endif()
