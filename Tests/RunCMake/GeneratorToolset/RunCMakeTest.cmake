include(RunCMake)

if("${RunCMake_GENERATOR}" MATCHES "Visual Studio")
  run_cmake(VsNormal)
  include("${RunCMake_BINARY_DIR}/VsNormal-build/defaults.cmake" OPTIONAL)
  message(STATUS "VsNormal: platform='${VsNormal_Platform}' toolset='${VsNormal_Toolset}'")
endif()

set(RunCMake_GENERATOR_TOOLSET "")
run_cmake(NoToolset)

if("${RunCMake_GENERATOR}" MATCHES "Visual Studio")
  set(RunCMake_GENERATOR_TOOLSET "Test Toolset")
  run_cmake(TestToolset)
  set(RunCMake_GENERATOR_TOOLSET "Test Toolset,cuda=0.0")
  run_cmake(TestToolsetCudaBoth)
  set(RunCMake_GENERATOR_TOOLSET ",cuda=0.0")
  run_cmake(TestToolsetCudaVersionOnly)
  set(RunCMake_GENERATOR_TOOLSET "cuda=0.0")
  run_cmake(TestToolsetCudaVersionOnly)
  set(RunCMake_GENERATOR_TOOLSET "cuda=${CMAKE_CURRENT_BINARY_DIR}/CudaStandaloneToolset")
  run_cmake(TestToolsetCudaPathOnly)
  set(RunCMake_GENERATOR_TOOLSET "cuda=${CMAKE_CURRENT_BINARY_DIR}/CudaStandaloneToolset")
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/CudaStandaloneToolset/CUDAVisualStudioIntegration")
  run_cmake(TestToolsetCudaPathOnlyOldLayout)
  file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/CudaStandaloneToolset")
  if (VsNormal_Platform MATCHES "^(x64|Win32)$" AND
      EXISTS "${CMAKE_ROOT}/Templates/MSBuild/FlagTables/${VsNormal_Toolset}_CL.json")
    set(flagTableDir "${RunCMake_BINARY_DIR}/FlagTables")
    file(READ "${CMAKE_ROOT}/Templates/MSBuild/FlagTables/${VsNormal_Toolset}_CL.json" flagTableContent)
    string(REPLACE [["WX-"]] [["TESTWX-"]] flagTableContent "${flagTableContent}")
    file(REMOVE_RECURSE "${flagTableDir}")
    file(WRITE "${flagTableDir}/${VsNormal_Platform}_${VsNormal_Toolset}_CL.json" "${flagTableContent}")
    set(RunCMake_GENERATOR_TOOLSET "${VsNormal_Toolset},customFlagTableDir=${flagTableDir}")
    set(RunCMake_TEST_VARIANT_DESCRIPTION ":${VsNormal_Platform}_${VsNormal_Toolset}_CL.json")
    run_cmake(TestToolsetCustomFlagTableDir)
    file(REMOVE_RECURSE "${flagTableDir}")
    file(WRITE "${flagTableDir}/${VsNormal_Platform}_CL.json" "${flagTableContent}")
    set(RunCMake_GENERATOR_TOOLSET "${VsNormal_Toolset},customFlagTableDir=${flagTableDir}")
    set(RunCMake_TEST_VARIANT_DESCRIPTION ":${VsNormal_Platform}_CL.json")
    run_cmake(TestToolsetCustomFlagTableDir)
    unset(RunCMake_TEST_VARIANT_DESCRIPTION)
    set(RunCMake_GENERATOR_TOOLSET "${VsNormal_Toolset},customFlagTableDir=does_not_exist")
    run_cmake(BadToolsetCustomFlagTableDir)
  endif()
  set(RunCMake_GENERATOR_TOOLSET "fortran=ifort")
  run_cmake(TestToolsetFortranIFORT)
  set(RunCMake_GENERATOR_TOOLSET "fortran=ifx")
  run_cmake(TestToolsetFortranIFX)
  set(RunCMake_GENERATOR_TOOLSET "fortran=bad")
  run_cmake(BadToolsetFortran)
  if("${RunCMake_GENERATOR}" MATCHES "Visual Studio")
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,host=x64")
    run_cmake(TestToolsetHostArchBoth)
    set(RunCMake_GENERATOR_TOOLSET ",host=x64")
    run_cmake(TestToolsetHostArchOnly_x64)
    set(RunCMake_GENERATOR_TOOLSET "host=x64")
    run_cmake(TestToolsetHostArchOnly_x64)
    set(RunCMake_GENERATOR_TOOLSET "host=x86")
    run_cmake(TestToolsetHostArchOnly_x86)
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset")
    run_cmake(TestToolsetHostArchNone)
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,host=x65")
    run_cmake(BadToolsetHostArch)
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,host=x64,host=x86")
    run_cmake(BadToolsetHostArchTwice)
    if("${RunCMake_GENERATOR}" MATCHES "Visual Studio 1[567]")
      set(RunCMake_GENERATOR_TOOLSET "VCTargetsPath=Test Path")
      run_cmake(TestToolsetVCTargetsPathOnly)
      set(RunCMake_GENERATOR_TOOLSET "Test Toolset,version=Test Toolset Version")
      run_cmake(TestToolsetVersionBoth)
      set(RunCMake_GENERATOR_TOOLSET ",version=Test Toolset Version")
      run_cmake(TestToolsetVersionOnly)
      set(RunCMake_GENERATOR_TOOLSET "version=Test Toolset Version")
      run_cmake(TestToolsetVersionOnly)
      set(RunCMake_GENERATOR_TOOLSET "Test Toolset,version=Bad Toolset Version")
      run_cmake(BadToolsetVersion)
      set(RunCMake_GENERATOR_TOOLSET "Test Toolset,version=Test Toolset Version,version=Test Toolset Version")
      run_cmake(BadToolsetVersionTwice)
    endif()
  else()
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,host=x64")
    run_cmake(BadToolsetHostArch)
  endif()
  set(RunCMake_GENERATOR_TOOLSET "Test Toolset,not_a_key")
  run_cmake(BadToolsetFormat)
elseif("${RunCMake_GENERATOR}" STREQUAL "Xcode")
  set(RunCMake_GENERATOR_TOOLSET "Test Toolset")
  run_cmake(TestToolset)
  set(RunCMake_GENERATOR_TOOLSET "Test Toolset,host=x64")
  run_cmake(BadToolsetHostArchXcode)
  set(RunCMake_GENERATOR_TOOLSET "buildsystem=bad")
  run_cmake(BadToolsetXcodeBuildSystem)
  if(XCODE_VERSION VERSION_GREATER_EQUAL 12)
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset")
    run_cmake(TestToolsetXcodeBuildSystemDefault12)
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,buildsystem=1")
    if(XCODE_VERSION VERSION_GREATER_EQUAL 14)
      run_cmake(BadToolsetXcodeBuildSystem1)
    else()
      run_cmake(TestToolsetXcodeBuildSystem1)
    endif()
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset,buildsystem=12")
    run_cmake(TestToolsetXcodeBuildSystem12)
  else()
    set(RunCMake_GENERATOR_TOOLSET "Test Toolset")
    run_cmake(TestToolsetXcodeBuildSystemDefault1)
    set(RunCMake_GENERATOR_TOOLSET "buildsystem=12")
    run_cmake(BadToolsetXcodeBuildSystem12)
  endif()
else()
  set(RunCMake_GENERATOR_TOOLSET "Bad Toolset")
  run_cmake(BadToolset)
endif()

set(RunCMake_GENERATOR_TOOLSET "")

set(RunCMake_TEST_OPTIONS -T "Test Toolset" -T "Extra Toolset")
run_cmake(TwoToolsets)
unset(RunCMake_TEST_OPTIONS)

if("${RunCMake_GENERATOR}" MATCHES "Visual Studio|Xcode")
  set(RunCMake_TEST_OPTIONS -DCMAKE_TOOLCHAIN_FILE=${RunCMake_SOURCE_DIR}/TestToolset-toolchain.cmake)
  run_cmake(TestToolsetToolchain)
  unset(RunCMake_TEST_OPTIONS)
else()
  set(RunCMake_TEST_OPTIONS -DCMAKE_TOOLCHAIN_FILE=${RunCMake_SOURCE_DIR}/BadToolset-toolchain.cmake)
  run_cmake(BadToolsetToolchain)
  unset(RunCMake_TEST_OPTIONS)
endif()
