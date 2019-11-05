#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=main.asm config.asm Setup.asm RA8875.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/Setup.o ${OBJECTDIR}/RA8875.o
POSSIBLE_DEPFILES=${OBJECTDIR}/main.o.d ${OBJECTDIR}/config.o.d ${OBJECTDIR}/Setup.o.d ${OBJECTDIR}/RA8875.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/main.o ${OBJECTDIR}/config.o ${OBJECTDIR}/Setup.o ${OBJECTDIR}/RA8875.o

# Source Files
SOURCEFILES=main.asm config.asm Setup.asm RA8875.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=18f87k22
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/main.lst\" -e\"${OBJECTDIR}/main.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/main.o\" \"main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/config.o: config.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o.d 
	@${RM} ${OBJECTDIR}/config.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/config.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/config.lst\" -e\"${OBJECTDIR}/config.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/config.o\" \"config.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/config.o"
	@${FIXDEPS} "${OBJECTDIR}/config.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Setup.o: Setup.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Setup.o.d 
	@${RM} ${OBJECTDIR}/Setup.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Setup.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Setup.lst\" -e\"${OBJECTDIR}/Setup.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Setup.o\" \"Setup.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Setup.o"
	@${FIXDEPS} "${OBJECTDIR}/Setup.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/RA8875.o: RA8875.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/RA8875.o.d 
	@${RM} ${OBJECTDIR}/RA8875.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/RA8875.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_ICD3=1 -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/RA8875.lst\" -e\"${OBJECTDIR}/RA8875.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/RA8875.o\" \"RA8875.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/RA8875.o"
	@${FIXDEPS} "${OBJECTDIR}/RA8875.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/main.o: main.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/main.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/main.lst\" -e\"${OBJECTDIR}/main.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/main.o\" \"main.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/main.o"
	@${FIXDEPS} "${OBJECTDIR}/main.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/config.o: config.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/config.o.d 
	@${RM} ${OBJECTDIR}/config.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/config.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/config.lst\" -e\"${OBJECTDIR}/config.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/config.o\" \"config.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/config.o"
	@${FIXDEPS} "${OBJECTDIR}/config.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/Setup.o: Setup.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Setup.o.d 
	@${RM} ${OBJECTDIR}/Setup.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/Setup.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/Setup.lst\" -e\"${OBJECTDIR}/Setup.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/Setup.o\" \"Setup.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/Setup.o"
	@${FIXDEPS} "${OBJECTDIR}/Setup.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/RA8875.o: RA8875.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/RA8875.o.d 
	@${RM} ${OBJECTDIR}/RA8875.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/RA8875.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/RA8875.lst\" -e\"${OBJECTDIR}/RA8875.err\" $(ASM_OPTIONS)    -o\"${OBJECTDIR}/RA8875.o\" \"RA8875.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/RA8875.o"
	@${FIXDEPS} "${OBJECTDIR}/RA8875.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_ICD3=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -m"${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map"   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/Project.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif