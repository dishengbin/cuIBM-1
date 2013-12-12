include Makefile.inc

#test:
#	echo $(PROJ_ROOT)
#	echo $(dir $(lastword $(MAKEFILE_LIST)))

# just so that make is not confused if there exist
# files called cuibm or clean
# a phony target is a name for a recipe to be executed with an explicit request
.PHONY: cuibm src/solvers/libsolvers.a

# this is the command called when 'make' is run in the command line
main: cuibm

# libraries generated by compiling the code
LIBS = lib/libNavierStokesSolvers.a lib/libIO.a

# library generate by compiling the YAML headers
EXT_LIBS = external/lib/libyaml-cpp.a

# final library
FINAL_LIB = lib/libcuIBM.a

# everything after the colon is a prerequisite
# they are all targets that are executed in order before the current target
# if the targets are not explicitly defined, implicit rules are used
# targets are the usually the names of the files generated

# the implicit rule .cu.o converts src/parameterDB.cu to src/parameterDB.o

# link all the object files and libraries to create the executable bin/cuIBM
cuibm: $(LIBS) $(EXT_LIBS) src/helpers.o src/parameterDB.o src/bodies.o src/cuIBM.o
	nvcc $^ -o bin/cuIBM

#src/preconditioner.o

#lib/libcuIBM.a: $(LIBS) $(EXT_LIBS)
#	cd lib; libtool -static -o libcuIBM.a $^

#  force_look is a dependency
#  it is always true. So this command is always executed
#  MFLAGS is used to transfer command line options to the sub-makes
lib/libNavierStokesSolvers.a: force_look
	cd src/solvers; $(MAKE) $(MFLAGS)
  
lib/libIO.a: force_look
	cd src/io/; $(MAKE) $(MFLAGS)

external/lib/libyaml-cpp.a:
	cd external; $(MAKE) $(MFLAGS) all

#  deletes all the object files
#  it seems MFLAGS hasn't been defined anywhere. The defaults are probably used.
#  @ at the beginning of a line suppresses output. This works only in Makefiles.
#  1. delete all the .a and .o files
#  2. cd to the concerned folders
#  3. run 'make clean' as defined in the Makefiles in those folders
.PHONY: clean cleanall

clean:
	@rm -f lib/*.a bin/cuIBM src/*.o
	cd src/solvers; $(MAKE) $(MFLAGS) clean
	cd src/io; $(MAKE) $(MFLAGS) clean

cleanall:
	@rm -f lib/*.a bin/cuIBM src/*.o
	cd src/solvers; $(MAKE) $(MFLAGS) clean
	cd src/io; $(MAKE) $(MFLAGS) clean
	cd external; $(MAKE) $(MFLAGS) clean

#
force_look:
	true

#
#.PHONY: test test2
.PHONY: test
.PHONY: cavity LidDrivenCavityRe100 LidDrivenCavityRe1000
.PHONY: cylinder cylinderFadlun cylinderRe40 cylinderRe550 cylinderRe3000 movingCylinder
.PHONY: cylinderRe75 cylinderRe100 cylinderRe150
.PHONY: flapping flappingRe75
.PHONY: snakeRe1000AOA30 snakeRe1000AOA35 snakeRe2000AOA30 snakeRe2000AOA35

#test:
#	bin/cuIBM \
#		-flowFile flows/test.yaml -domainFile domains/test.yaml \
#		-bodyFile bodies/empty.yaml -simulationFile simParams/test.yaml \
#		-folderName test

#test2:
#	bin/cuIBM \
#		-flowFile flows/test.yaml -domainFile domains/test2.yaml \
#		-bodyFile bodies/test2.yaml -simulationFile simParams/test2.yaml \
#		-folderName test2

cavity:
	bin/cuIBM \
	-flowFile flows/cavity.yaml -domainFile domains/cavity.yaml \
	-bodyFile bodies/empty.yaml -simulationFile simParams/cavity.yaml \
	-folderName cavity

LidDrivenCavityRe100:
	bin/cuIBM \
	-flowFile flows/cavity.yaml -domainFile domains/cavity0100.yaml \
	-bodyFile bodies/empty.yaml -simulationFile simParams/cavity0100.yaml \
	-folderName LidDrivenCavityRe100 \
	-nu 0.01

LidDrivenCavityRe1000:
	bin/cuIBM \
	-flowFile flows/cavity.yaml -domainFile domains/cavity1000.yaml \
	-bodyFile bodies/empty.yaml -simulationFile simParams/cavity1000.yaml \
	-folderName LidDrivenCavityRe1000 \
	-nu 0.001

cylinder:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/openFlow.yaml \
	-bodyFile bodies/cylinder.yaml -simulationFile simParams/openFlow.yaml \
	-folderName cylinder

cylinderFadlun:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/openFlow.yaml \
	-bodyFile bodies/cylinder.yaml -simulationFile simParams/openFlowFadlun.yaml \
	-folderName cylinderFadlun -ibmScheme FadlunEtAl

movingCylinder:
	bin/cuIBM \
	-flowFile flows/box.yaml -domainFile domains/movingCylinder.yaml \
	-bodyFile bodies/movingCylinder.yaml -simulationFile simParams/movingCylinder.yaml \
	-folderName movingCylinder \
	-nu 0.025

cylinderRe40:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/openFlow0.025.yaml \
	-bodyFile bodies/cylinder0.025.yaml -simulationFile simParams/cylinder0040.yaml \
	-folderName cylinderRe40 \
	-nu 0.025

cylinderRe75:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/vonKarmanStreet.yaml \
	-bodyFile bodies/cylinder0.020.yaml -simulationFile simParams/vonKarmanStreet.yaml \
	-folderName cylinderRe75 \
	-nu 0.013333333333 -uPerturb 0.1

cylinderRe100:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/vonKarmanStreet.yaml \
	-bodyFile bodies/cylinder0.020.yaml -simulationFile simParams/vonKarmanStreet.yaml \
	-folderName cylinderRe100 \
	-nu 0.01 -uPerturb 0.1

cylinderRe150:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/vonKarmanStreet.yaml \
	-bodyFile bodies/cylinder0.020.yaml -simulationFile simParams/vonKarmanStreet.yaml \
	-folderName cylinderRe150 \
	-nu 0.0066666666666 -uPerturb 0.1

cylinderRe550:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/openFlow0.010.yaml \
	-bodyFile bodies/cylinder0.010.yaml -simulationFile simParams/cylinder0550.yaml \
	-folderName cylinderRe550 \
	-nu 0.00181818181818

cylinderRe3000:
	bin/cuIBM \
	-flowFile flows/openFlow.yaml -domainFile domains/openFlow0.004.yaml \
	-bodyFile bodies/cylinder0.004.yaml -simulationFile simParams/cylinder3000.yaml \
	-folderName cylinderRe3000 \
	-nu 0.00033333333333

flapping:
	bin/cuIBM \
	-flowFile flows/box.yaml -domainFile domains/flapping.yaml \
	-bodyFile bodies/flapping.yaml -simulationFile simParams/flapping.yaml \
	-folderName flapping

flappingRe75:
	time bin/cuIBM \
	-flowFile flows/box.yaml -domainFile domains/flappingRe75.yaml \
	-bodyFile bodies/flappingRe75.yaml -simulationFile simParams/flappingRe75.yaml \
	-folderName flappingRe75

snakeRe1000AOA30:
	time bin/cuIBM \
	-ibmScheme TairaColonius \
	-flowFile flows/openFlow.yaml -nu 0.001 \
	-domainFile domains/snake.yaml \
	-bodyFile bodies/snake/snake30.yaml -simulationFile simParams/snake.yaml \
	-folderName snakeRe1000AOA30

snakeRe1000AOA35:
	time bin/cuIBM \
	-ibmScheme TairaColonius \
	-flowFile flows/openFlow.yaml -nu 0.001 \
	-domainFile domains/snake.yaml \
	-bodyFile bodies/snake/snake35.yaml -simulationFile simParams/snake.yaml \
	-folderName snakeRe1000AOA35

snakeRe2000AOA30:
	time bin/cuIBM \
	-ibmScheme TairaColonius \
	-flowFile flows/openFlow.yaml -nu 0.0005 \
	-domainFile domains/snake.yaml \
	-bodyFile bodies/snake/snake30.yaml -simulationFile simParams/snake.yaml \
	-folderName snakeRe2000AOA30

snakeRe2000AOA35:
	time bin/cuIBM \
	-ibmScheme TairaColonius \
	-flowFile flows/openFlow.yaml -nu 0.0005 \
	-domainFile domains/snake.yaml \
	-bodyFile bodies/snake/snake35.yaml -simulationFile simParams/snake.yaml \
	-folderName snakeRe2000AOA35
