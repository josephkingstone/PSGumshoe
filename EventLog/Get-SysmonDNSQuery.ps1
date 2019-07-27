function Get-SysmonDNSQuery {
    <#
    .SYNOPSIS
        Get Sysmon Access Procces EventLog Events (EventId 22).
    .DESCRIPTION
        Get Sysmon DNS Query events either locally or remotely from a specified location.
        These events have an EventID of 10 and are for tracking DNS queries performed by processes.
    .EXAMPLE
        PS C:\> Get-SysmonDNSQuery | Group-Object -Property query | Select-Object -Property count,name
        Get a list of processes and count of DNS queries logged.
    .EXAMPLE
        PS C:\> Get-SysmonDNSQuery | Group-Object -Property query | Select-Object -Property count,name
        Get a list of unique queries logged and a count for each.
    .EXAMPLE
        PS C:\> Get-SysmonDNSQuery -QueryStatus 0 -QueryName wpad
        Get a list of successful WPAD resolutions.
    .EXAMPLE
        PS C:\> Get-SysmonDNSQuery -QueryStatus 9003 
        Get a list of queries for where the DNS Name does not exist.
    .EXAMPLE
        PS C:\> Get-SysmonDNSQuery -QueryStatus 9501 
        Get a list of queries for where no record was found.
    .INPUTS
        System.IO.FileInfo
    .OUTPUTS
    Sysmon.EventRecord.DNSQuery
    .NOTES
        The number of events for this type may be a high one if there is no proper filtering in place for collection. 
        DNS Status List https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes--9000-11999-
    #>
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param (
        # Log name for where the events are stored.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]
        $LogName = 'Microsoft-Windows-Sysmon/Operational',

        # The PID of the process that is performing the query.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int[]]
        $ProcessId,

        # The unique Process GUID of the process that is performing the query.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ProcessGuid,

        # Rule Name for filter that generated the event.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $RuleName,

        # FQDN that was queried.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $QueryName,

        # Status of the query perfomed.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $QueryStatus,

        # Image of the process that perforemd the query.
        [Parameter(Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Image,

        # Specifies the path to the event log files that this cmdlet get events from. Enter the paths to the log files in a comma-separated list, or use wildcard characters to create file path patterns. Function supports files with the .evtx file name extension. You can include events from different files and file types in the same command.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="file",
                   ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,


        # Gets events from the event logs on the specified computer. Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        # The default value is the local computer.
        # To get events and event logs from remote computers, the firewall port for the event log service must be configured to allow remote access.
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'Remote')]
        [string[]]
        $ComputerName,

        # Specifies a user account that has permission to perform this action.
        #
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, you will
        # be prompted for a password. If you type only the parameter name, you will be prompted for both a user name and a password.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Remote')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        # Specifies the maximum number of events that are returned. Enter an integer. The default is to return all the events in the logs or files.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int64]
        $MaxEvents,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $StartTime,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $EndTime,

        # Changes the default logic for matching fields from 'and' to 'or'.
        [Parameter(Mandatory = $false)]
        [switch]
        $ChangeLogic
    )

    begin {}

    process {
        Search-SysmonEvent -EventId 22 -ParamHash $MyInvocation.BoundParameters

    }

    end {}
}