@ECHO OFF

@ECHO Stopping tb-snmp-transport ...
net stop tb-snmp-transport

@ECHO Uninstalling tb-snmp-transport ...
"%~dp0"tb-snmp-transport.exe uninstall

@ECHO DONE.