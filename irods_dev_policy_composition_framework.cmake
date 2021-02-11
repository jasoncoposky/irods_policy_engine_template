set(POLICY_NAME "irods_dev_policy_composition_framework")

string(REPLACE "_" "-" POLICY_NAME_HYPHENS ${POLICY_NAME})
set(IRODS_PACKAGE_COMPONENT_POLICY_NAME "${POLICY_NAME_HYPHENS}${IRODS_PACKAGE_FILE_NAME_SUFFIX}")
string(TOUPPER ${IRODS_PACKAGE_COMPONENT_POLICY_NAME} IRODS_PACKAGE_COMPONENT_POLICY_NAME_UPPERCASE)

set(TARGET_NAME "${POLICY_NAME}")
string(REPLACE "_" "-" TARGET_NAME_HYPHENS ${TARGET_NAME})

set(
  IRODS_PLUGIN_POLICY_COMPILE_DEFINITIONS
  RODS_SERVER
  ENABLE_RE
  )

set(
  IRODS_PLUGIN_POLICY_LINK_LIBRARIES
  irods_server
  )

add_library(
    ${TARGET_NAME}
    MODULE
    policy_composition_framework_utilities.cpp
    )

set_property(TARGET ${TARGET_NAME} PROPERTY CXX_STANDARD ${IRODS_CXX_STANDARD})

target_include_directories(
    ${TARGET_NAME}
    PRIVATE
    ${IRODS_INCLUDE_DIRS}
    ${IRODS_EXTERNALS_FULLPATH_JSON}/include
    ${IRODS_EXTERNALS_FULLPATH_JANSSON}/include
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/include
    ${IRODS_EXTERNALS_FULLPATH_FMT}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    )

target_link_libraries(
    ${TARGET_NAME}
    PRIVATE
    ${IRODS_PLUGIN_POLICY_LINK_LIBRARIES}
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/lib/libboost_chrono.so
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/lib/libboost_filesystem.so
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/lib/libboost_thread.so
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/lib/libboost_regex.so
    ${IRODS_EXTERNALS_FULLPATH_BOOST}/lib/libboost_system.so
    ${IRODS_EXTERNALS_FULLPATH_FMT}/lib/libfmt.so
    irods_common
    )

target_compile_definitions(${TARGET_NAME} PRIVATE ${IRODS_PLUGIN_POLICY_COMPILE_DEFINITIONS} ${IRODS_COMPILE_DEFINITIONS} BOOST_SYSTEM_NO_DEPRECATED)
target_compile_options(${TARGET_NAME} PRIVATE -Wno-write-strings)
set_property(TARGET ${TARGET_NAME} PROPERTY CXX_STANDARD ${IRODS_CXX_STANDARD})

install(
  TARGETS
  ${TARGET_NAME}
  LIBRARY
  DESTINATION usr/lib
  COMPONENT ${IRODS_PACKAGE_COMPONENT_POLICY_NAME}
  )

install(
  FILES
  irods_dev_policy_composition_framework.cmake
  policy_composition_framework_cmake_utilities.cmake
  DESTINATION usr/lib/irods/cmake
  COMPONENT ${IRODS_PACKAGE_COMPONENT_POLICY_NAME}
  )

install(
  FILES
  policy_composition_framework_keywords.hpp
  policy_composition_framework_utilities.hpp
  policy_composition_framework_event_handler.hpp
  policy_composition_framework_policy_engine.hpp
  policy_composition_framework_parameter_capture.hpp
  policy_composition_framework_plugin_configuration_json.hpp
  policy_composition_framework_configuration_manager.hpp
  DESTINATION usr/include/irods
  COMPONENT ${IRODS_PACKAGE_COMPONENT_POLICY_NAME}
  )

install(
  FILES
  DESTINATION usr/include/irods
  COMPONENT ${IRODS_PACKAGE_COMPONENT_POLICY_NAME}
  )

set(CPACK_PACKAGE_VERSION ${IRODS_PLUGIN_VERSION})
set(CPACK_DEBIAN_${IRODS_PACKAGE_COMPONENT_POLICY_NAME_UPPERCASE}_FILE_NAME ${TARGET_NAME_HYPHENS}-${IRODS_PLUGIN_VERSION}-${IRODS_LINUX_DISTRIBUTION_NAME}-${IRODS_LINUX_DISTRIBUTION_VERSION_MAJOR}-${CMAKE_SYSTEM_PROCESSOR}.deb)

set(CPACK_DEBIAN_${IRODS_PACKAGE_COMPONENT_POLICY_NAME_UPPERCASE}_PACKAGE_NAME ${TARGET_NAME_HYPHENS})
set(CPACK_DEBIAN_${IRODS_PACKAGE_COMPONENT_POLICY_NAME_UPPERCASE}_PACKAGE_DEPENDS "${IRODS_PACKAGE_DEPENDENCIES_STRING}, irods-server (= ${IRODS_VERSION}), irods-runtime (= ${IRODS_VERSION}), libc6")

set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_POLICY_NAME}_PACKAGE_NAME ${TARGET_NAME_HYPHENS})
if (IRODS_LINUX_DISTRIBUTION_NAME STREQUAL "centos" OR IRODS_LINUX_DISTRIBUTION_NAME STREQUAL "centos linux")
    set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_POLICY_NAME_UPPERCASE}_FILE_NAME ${TARGET_NAME_HYPHENS}-${IRODS_PLUGIN_VERSION}-${IRODS_LINUX_DISTRIBUTION_NAME}-${IRODS_LINUX_DISTRIBUTION_VERSION_MAJOR}-${CMAKE_SYSTEM_PROCESSOR}.deb)
    set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_POLICY_NAME}_PACKAGE_REQUIRES "${IRODS_PACKAGE_DEPENDENCIES_STRING}, irods-server = ${IRODS_VERSION}, irods-runtime = ${IRODS_VERSION}, openssl")
elseif (IRODS_LINUX_DISTRIBUTION_NAME STREQUAL "opensuse")
    set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_POLICY_NAME}_PACKAGE_REQUIRES "${IRODS_PACKAGE_DEPENDENCIES_STRING}, irods-server = ${IRODS_VERSION}, irods-runtime = ${IRODS_VERSION}, libopenssl1_0_0")
endif()

