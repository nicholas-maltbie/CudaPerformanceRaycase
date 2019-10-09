# Makefile

CC=g++
NVCC=nvcc

CFLAGS		=
NVCCFLAGS	= 
LIBS		= -lGL -lGLU -lglut

INCLUDES=-I*.h

CPP_SRCS_RAY = 
CU_SRCS_RAY  = ray.cu 

CPP_SRCS_RAY_NOCONST = 
CU_SRCS_RAY_NOCONST  = ray_noconst.cu 

OBJS_RAY = $(CPP_SRCS_RAY:.cpp=.o)
OBJS_RAY += $(CU_SRCS_RAY:.cu=.o)

OBJS_RAY_NOCONST = $(CPP_SRCS_RAY_NOCONST:.cpp=.o)
OBJS_RAY_NOCONST += $(CU_SRCS_RAY_NOCONST:.cu=.o)

TARGET_RAY = ray
TARGET_RAY_NOCONST = ray_noconst

all: $(TARGET_RAY) $(TARGET_RAY_NOCONST)

$(TARGET_RAY): $(OBJS_RAY)
	$(NVCC) $(NVCCFLAGS) $< $(LIBS) -o $@

$(TARGET_RAY_NOCONST): $(OBJS_RAY_NOCONST)
	$(NVCC) $(NVCCFLAGS) $< $(LIBS) -o $@

.SUFFIXES: 

.SUFFIXES:  .cpp .cu .o

.cu.o:
	$(NVCC) -o $@ -c $<

.cpp.o:
	$(NVCC) -o $@ -c $<

clean:
	rm -rf $(TARGET_RAY) $(TARGET_RAY_NOCONST) *.o
