# Compiler and Linker, with Options (e.g. for "COMPILER.cpp")
CXX := cl
CXXFLAGS := -nologo -W3 -Zm300 -TP -EHsc -Ox -MT

LDFLAGS = -LIBPATH:$(LEDA_LIBRARY_DIR) -LIBPATH:$(SUGIYAMA_LIBRARY_DIR) -LIBPATH:$(IMPLEMENTATIONS_LIBRARY_DIR)

# Project-Directory-Structure
INCLUDE_DIR := incl
SOURCE_DIR := src
INTERMEDIATE_DIR := intermediates
BINARY_DIR := bin

# Relevant Source-Files
SOURCE_FILE_NAMES := demo.cpp demo_only_cycle_break.cpp

SOURCE_FILES := $(addprefix $(SOURCE_DIR)/, $(SOURCE_FILE_NAMES))

# Dependencies
SYSTEM_LIBS := user32.lib gdi32.lib msimg32.lib comdlg32.lib shell32.lib advapi32.lib wsock32.lib

LEDA_INCLUDE_DIR := ..\incl
LEDA_LIBRARY_DIR := ..\lib
LEDA_LIB := leda.lib

SUGIYAMA_INCLUDE_DIR := ..\architecture\incl
SUGIYAMA_LIBRARY_DIR := ..\architecture\bin
SUGIYAMA_LIB := sugiyama.lib

IMPLEMENTATIONS_INCLUDE_DIR := ..\implementation\incl
IMPLEMENTATIONS_LIBRARY_DIR := ..\implementation\bin
IMPLEMENTATIONS_LIB := sugi_impl.lib


.PHONY: all
all: $(BINARY_DIR)/demo.exe

$(BINARY_DIR)/%.exe: $(SUGIYAMA_LIBRARY_DIR)/$(SUGIYAMA_LIB) $(IMPLEMENTATIONS_LIBRARY_DIR)/$(IMPLEMENTATIONS_LIB)

$(BINARY_DIR)/%.exe: override CXXFLAGS += -nologo -MT

$(BINARY_DIR)/%.exe: $(INTERMEDIATE_DIR)/%.obj
	LINK.exe /OUT:$@ $(LDFLAGS) $(SYSTEM_LIBS) $(LEDA_LIB) $(SUGIYAMA_LIB) $(IMPLEMENTATIONS_LIB) $<

$(INTERMEDIATE_DIR)/%.obj: override CXXFLAGS += -nologo -W3 -c -Zm300 -TP -EHsc -Ox -MT

$(INTERMEDIATE_DIR)/%.obj: override CPPFLAGS += -I $(LEDA_INCLUDE_DIR) -I $(SUGIYAMA_INCLUDE_DIR) -I $(IMPLEMENTATIONS_INCLUDE_DIR)

$(INTERMEDIATE_DIR)/%.obj: $(SOURCE_DIR)/%.cpp
	$(COMPILE.cpp) $< -Fo$@
	
	
.PHONY: clean
clean:
	rm -f $(BINARY_DIR)/*
	rm -f $(INTERMEDIATE_DIR)/*