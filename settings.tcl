set EventLogger /usr/devopt/nscldaq/11.0/bin/eventlog
set EventLoggerRing tcp://localhost/built
set EventLogUseNsrcsFlag 1
set EventLogAdditionalSources 1
set EventLogUseGUIRunNumber 0
set EventLogUseChecksumFlag 1
set run 87
set title {CsrDaq + S800 Daq, no shared triggers, just software sync test}
set recording 1
set timedRun 1
set duration 600
set dataSources {{host spdaq45 provider RemoteGUI sourceid 0 user scinti} {delay 5000 provider Delay sourceid 1} {host spdaq48 port 8000 provider S800 sourceid 2}}
