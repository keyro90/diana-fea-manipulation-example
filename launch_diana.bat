@echo off

rem params: 2 = path dialogin,  3 = filename prefix

del diana.ff 2>nul

rem === Diana Environment Setup ===
call %2

set KMP_STACKSIZE=
set KMP_HANDLE_SIGNALS=
set KMP_BLOCKTIME=

rem You can force a specific filos file here...
rem SET "FF=%1.ff"
rem -m param log every single analysis step.
diana -m %1
