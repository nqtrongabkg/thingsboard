@ECHO OFF

@ECHO Stopping tb-lwm2m-transport ...
net stop tb-lwm2m-transport

@ECHO Uninstalling tb-lwm2m-transport ...
"%~dp0"tb-lwm2m-transport.exe uninstall

@ECHO DONE.