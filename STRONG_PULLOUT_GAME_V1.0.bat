@ECHO OFF
HOSTNAME > hostname
SET /P HOSTNAME= < hostname
DEL hostname
CLS
ECHO *************************************************************************************************************
ECHO *				  WELCOME TO StrongPulloutGame! 
ECHO * 				THIS SCRIPT PULLS OUT JUST IN TIME!                                                  
ECHO *			This script was written by: Nikolas Coleman 2021                                         
ECHO *	      I do not grant my permission for this script to reused without my consent.              
ECHO *	                                                                                                         
ECHO *		Feel free to send bitcoin to: bc1qv9p7fnkdf8k8j8j3qkrq5dk8sqjz9xl9hdrq9n                         
ECHO *                                                                                                           
ECHO *                                                                                                           
ECHO *                                                                                                           
ECHO **************************************************************************************************************
TIMEOUT /T 5
CLS
ECHO **************************************************************************************************************
ECHO *
ECHO *
ECHO *				Do you need to:
ECHO *					(1)EXPORT AUDIT POLICY FROM CURRENT SERVER/WORKSTATION
ECHO *					(2)EXPORT THE CURRENT SECURITY CONFIGURATION
ECHO *					(3)EXPORT THE LOCAL POLICY OBJECTS
ECHO *					(4)EXPORT WINDOWS DEFENDER FIREWALL  POLICY
ECHO *					(5)BACKUP BITLOCKER RECOVERY INFO FROM C: DRIVE
ECHO *					(6)PULL OUT SYSTEM INFO FROM CURRENT COMPUTER
ECHO *					(7)GET A LIST OF CURRENT USERS ON SYSTEM
ECHO *					(8)GET A LIST OF ALL PROGRAMS INSTALLED ON SYSTEM
ECHO *          (9)ALL THE ABOVE
ECHO *          (10)EXIT SCRIPT                      
ECHO *
ECHO *
SET /P USER_INPUT=" 				WHAT DO YOU NEED TO DO?[1-8]: "
IF /I %USER_INPUT%==1 (GOTO AUDIT_POLICY)
IF /I %USER_INPUT%==2 (GOTO SECURITY_POLICY)
IF /I %USER_INPUT%==3 (GOTO LOCAL_POLICY)
IF /I %USER_INPUT%==4 (GOTO FIREWALL)
IF /I %USER_INPUT%==5 (GOTO BITLOCKER)
IF /I %USER_INPUT%==6 (GOTO SYS_INFO)
IF /I %USER_INPUT%==7 (GOTO GET_USERS)
IF /I %USER_INPUT%==8 (GOTO GET_APPLICATIONS)
IF /I %USER_INPUT%==9 (GOTO ALL)
IF /I %USER_INPUT%==10 (GOTO CODE_EXIT)

:AUDIT_POLICY
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%		
auditpol /backup /file:%DIRECTORY%%HOSTNAME%\auditpolicy.csv
GOTO CODE_EXIT

:SECURITY_POLICY
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME% 
secedit /export /cfg %DIRECTORY%%HOSTNAME%\securitypolicy.inf
GOTO CODE_EXIT

:LOCAL_POLICY
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
XCOPY C:\Windows\System32\GroupPolicy\* %DIRECTORY%%HOSTNAME%\PolicyObjects /E /H /C /I
GOTO CODE_EXIT

:FIREWALL
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
NETSH ADVFIREWALL EXPORT %DIRECTORY%%HOSTNAME%\firewall-policy.wfw
GOTO CODE_EXIT

:BITLOCKER
REM IF BITLOCKER IS NOT INSTALLED IT WILL CREATE A BLANK FILE PLEASE MAKE SURE IT IS IN FACT INSTALLED ON THE SYSTEM  BEFORE RUNNING 
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
MANAGE-BDE -PROTECTORS C: -GET > %DIRECTORY%%HOSTNAME%\BITLOCKER_INFO_FOR_%HOSTNAME%.TXT
GOTO CODE_EXIT

:SYS_INFO
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
SYSTEMINFO > %DIRECTORY%%HOSTNAME%\SYSTEM_INFO_FOR_%HOSTNAME%.TXT
GOTO CODE_EXIT

:GET_USERS
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
POWERSHELL -ExecutionPolicy Bypass -File "%DIRECTORY%GET_LOCAL_USERS.ps1"
XCOPY C:\Users\ESSAdmin\Desktop\user_list.txt %DIRECTORY%%HOSTNAME%\USER_LIST_FOR_%HOSTNAME%.TXT
DEL C:\Users\ESSAdmin\Desktop\user_list.txt
GOTO CODE_EXIT

REM WE SHOULD ADD AN OPTION FOR WORKSTATIONS OR SERVERS SINCE THIS COMMAND WORKS GREAT ON SERVERS BUT NOT SO MUCH ON WORKSTATIONS WMIC WORKS GREAT ON WORKSTATIONS LET'S IMPLEMENT THIS  LATER
:GET_APPLICATIONS
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
MKDIR %DIRECTORY%%HOSTNAME%
POWERSHELL -ExecutionPolicy Bypass -File "%DIRECTORY%LIST_APPLICATIONS.ps1"
XCOPY C:\Users\ESSAdmin\Desktop\installed_programs.txt %DIRECTORY%%HOSTNAME%\APPLICATION_LIST_FOR_%HOSTNAME%.TXT
DEL C:\Users\ESSAdmin\Desktop\installed_programs.txt
GOTO CODE_EXIT

:ALL
SET /P DIRECTORY=" PLEASE PASTE IN DESTINATION DIRECTORY TO PUT FILE: "
mkdir %DIRECTORY%%HOSTNAME% 
auditpol /backup /file:%DIRECTORY%%HOSTNAME%\auditpolicy.csv
secedit /export /cfg %DIRECTORY%%HOSTNAME%\securitypolicy.inf
XCOPY C:\Windows\System32\GroupPolicy\* %DIRECTORY%%HOSTNAME%\PolicyObjects /E /H /C /I
NETSH ADVFIREWALL EXPORT %DIRECTORY%%HOSTNAME%\firewall-policy.wfw
MANAGE-BDE -PROTECTORS C: -GET > %DIRECTORY%%HOSTNAME%\BITLOCKER_INFO_FOR_%HOSTNAME%.TXT
SYSTEMINFO > %DIRECTORY%%HOSTNAME%\SYSTEM_INFO_FOR_%HOSTNAME%.TXT
POWERSHELL -ExecutionPolicy Bypass -File "%DIRECTORY%GET_LOCAL_USERS.ps1"
XCOPY C:\Users\ESSAdmin\Desktop\user_list.txt %DIRECTORY%%HOSTNAME%\USER_LIST_FOR_%HOSTNAME%.TXT
DEL C:\Users\ESSAdmin\Desktop\user_list.txt
POWERSHELL -ExecutionPolicy Bypass -File "%DIRECTORY%LIST_APPLICATIONS.ps1"
XCOPY C:\Users\ESSAdmin\Desktop\installed_programs.txt %DIRECTORY%%HOSTNAME%\APPLICATION_LIST_FOR_%HOSTNAME%.TXT
DEL C:\Users\ESSAdmin\Desktop\installed_programs.txt
GOTO CODE_EXIT

:CODE_EXIT
ECHO EXITING!
PAUSE
EXIT
