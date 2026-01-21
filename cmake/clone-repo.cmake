# Calling FetchContent_Populate() with a single argument is deprecated >= 3.30
if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.30")
    cmake_policy(SET CMP0169 OLD)
endif()

# Checkout remote repository
macro(clone_repo name url tag)
    string(TOLOWER ${name} name_lower)
    string(TOUPPER ${name} name_upper)

    if(NOT ${name_upper}_REPOSITORY)
        set(${name_upper}_REPOSITORY ${url})
    endif()
    if(NOT ${name_upper}_TAG)
        set(${name_upper}_TAG ${tag})
    endif()

    message(STATUS "Fetching ${name} ${${name_upper}_REPOSITORY} ${${name_upper}_TAG}")

    include(FetchContent)

    FetchContent_Declare(${name}
        GIT_REPOSITORY ${${name_upper}_REPOSITORY}
        GIT_TAG ${${name_upper}_TAG}
        SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps/${name_lower}-src)

    FetchContent_GetProperties(${name} POPULATED ${name_lower}_POPULATED)

    if(NOT ${name_lower}_POPULATED)
        FetchContent_Populate(${name})
    endif()

    set(${name_upper}_SOURCE_DIR ${${name_lower}_SOURCE_DIR})
    set(${name_upper}_BINARY_DIR ${${name_lower}_BINARY_DIR})
endmacro()