cmake_minimum_required(VERSION 3.0)

project(qttouchbar)

find_package(Qt5Widgets REQUIRED)

add_executable(qttouchbar main.mm)

target_link_libraries(qttouchbar Qt5::Widgets "-framework Foundation" "-framework Cocoa" objc)
