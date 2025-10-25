@echo off
REM Run PowerShell Core as Administrator
powershell -Command "Start-Process pwsh.exe -Verb runAs"