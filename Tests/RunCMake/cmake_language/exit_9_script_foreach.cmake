foreach(i IN ITEMS a b)
  cmake_language(EXIT 9)
  message(FATAL_ERROR "This should not be reached!")
endforeach()
message(FATAL_ERROR "This should not be reached!")