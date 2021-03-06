Function Get-ADPrintQueue {
<#
.Synopsis
	���������� ���� ��� ��������� �������� AD � ������� printQueue. 
.Description
	Get-ADPrintQueue ���������� ������ printQueue ��� ��������� ����� ��� ��������� ���������
	�������� ADObject ������ printQueue.
			
	�������� `Identity` (��. about_ActiveDirectory_Identity) ��������� ������ Active Directory ������ printQueue.
	�� ������ ���������������� ������� ������ ����� ������ ��� (DN), GUID, ��� printQueue ��� (CN).
	�� ������ ������� ���� �������� ���� ��� �������� ��� �� ���������.
	
	��� ������ � �������� ���������� �������� ����������� ��������� `Filter` ��� `LDAPFilter`.
	�������� `Filter` ���������� PowerShell Expression Language ��� ������ ������ �������
	��� Active Directory (��. about_ActiveDirectory_Filter).
	���� �� ��� ������ LDAP ������, ����������� �������� `LDAPFilter`.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ����������� ���������� `Identity`.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ���� ��� ��������� �������� ������ printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
	���������� ��� ������� ������ � ���������� 'OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM'.
#>
	[CmdletBinding(
		DefaultParametersetName = 'Filter'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue'
	)]

	param (
		# ������ � ���������� PowerShell Expression Language (��. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $false
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter = '*'
	,
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# ������ ������� � ���������� ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# �������� ������� ������� printQueue ��� ������� �� ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties = @(
			'DistinguishedName'
			, 'Name'
			, 'printerName'
			, 'printShareName'
			, 'serverName'
			, 'uNCName'
			, 'driverName'
			, 'driverVersion'
			, 'location'
			, 'portName'
			, 'printAttributes'
			, 'printBinNames'
			, 'printCollate'
			, 'printColor'
			, 'printDuplexSupported'
			, 'printFormName'
			, 'printKeepPrintedJobs'
			, 'printLanguage'
			, 'printMACAddress'
			, 'printNetworkAddress'
			, 'printMaxCopies'
			, 'printMaxResolutionSupported'
			, 'printMaxXExtent'
			, 'printMaxYExtent'
			, 'printMinXExtent'
			, 'printMinYExtent'
			, 'printMediaReady'
			, 'printMediaSupported'
			, 'printOrientationsSupported'
			, 'printPagesPerMinute'
			, 'printSpooling'
			, 'printStaplingSupported'
			, 'ObjectClass'
			, 'ObjectGUID'
		)
	,
		# ���������� ��������, ���������� � ���� �������� ��� ldap ������
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultPageSize = 256
	,
		# ������������ ���������� ������������ �������� AD
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultSetSize = $null
	,
		# ���� � ���������� AD, � ������� ��������� ����������� �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	begin {
		try {
			foreach ( $param in 'Properties' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			switch ( $PsCmdlet.ParameterSetName ) {
				'Identity' {
				}
				'Filter' {
					if ( $Filter -eq '*' ) {
						$PSBoundParameters['Filter'] = "objectClass -eq 'printQueue'";
					} else {
						$PSBoundParameters['Filter'] = "(objectClass -eq 'printQueue') -and ($Filter)";
					};
				}
				'LDAPFilter' {
					$PSBoundParameters['LDAPFilter'] = "(& (objectClass=printQueue) ($LDAPFilter))";
				}
			};
			$outBuffer = $null;
			if ( $PSBoundParameters.TryGetValue( 'OutBuffer', [ref]$outBuffer ) ) {
				$PSBoundParameters['OutBuffer'] = 1;
			};
			$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
				'Get-ADObject'
				, [System.Management.Automation.CommandTypes]::Cmdlet
			);
			$scriptCmd = { & $wrappedCmd `
				-Properties $Properties `
				@PSBoundParameters `
			};
			$steppablePipeline = $scriptCmd.GetSteppablePipeline( $myInvocation.CommandOrigin );
			$steppablePipeline.Begin( $PSCmdlet );
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
	process {
		try {
			$steppablePipeline.Process( $_ );
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
	end {
		try {
			$steppablePipeline.End();
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinter -Value Get-ADPrintQueue -Force;

Function Test-ADPrintQueue {
<#
.Synopsis
	���������� ���������� �� ������ AD � ������� printQueue � ���������� ���������.
.Description
	Test-ADPrintQueue ��������� ����� ��� ��������� ���������
	�������� ADObject ������ printQueue � ���������� ����������������, � ����������
	`$true` ���� ����� ������� ����, � `$false` � ��������� ������.
			
	�������� `Identity` (��. about_ActiveDirectory_Identity) ��������� ������ Active Directory ������ printQueue.
	�� ������ ���������������� ������� ������ ����� ������ ��� (DN), GUID, ��� printQueue ��� (CN).
	�� ������ ������� ���� �������� ���� ��� �������� ��� �� ���������.
	
	��� ������ � �������� ���������� �������� ����������� ��������� `Filter` ��� `LDAPFilter`.
	�������� `Filter` ���������� PowerShell Expression Language ��� ������ ������ �������
	��� Active Directory (��. about_ActiveDirectory_Filter).
	���� �� ��� ������ LDAP ������, ����������� �������� `LDAPFilter`.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ����������� ���������� `Identity`.
.Outputs
	bool
	������ - �������, ��������������� ��������� ������������, ����������;
	���� - �� ����������
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueue
.Link
	Get-ADPrintQueue
.Example
	Test-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
#>
	[CmdletBinding(
		DefaultParametersetName = 'Filter'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueue'
	)]

	param (
		# ������ � ���������� PowerShell Expression Language (��. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter
	,
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# ������ ������� � ���������� ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# ���� � ���������� AD, � ������� ��������� ����������� �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		[bool] ( Get-ADPrintQueue @PSBoundParameters );
	}
}

New-Alias -Name Test-ADPrinter -Value Test-ADPrintQueue -Force;

Function Initialize-ADPrintQueuesEnvironment {
<#
.Synopsis
	������ �������� ��������� ��� ����������� �������� printQueue. 
.Description
	������ �������� ��������� ��� ����������� �������� printQueue.
	������ ������� ������� �������� ���������� ��� �������� �����������
	����������� � ��������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� �������� ��������� ��� ����� -PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment
.Link
	Get-ADObject
.Example
	Initialize-ADPrintQueuesEnvironment
	������ �������� ��������� � ����������� �� ���������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment'
	)]

	param (
		# �����, � ������� �������������� ��������� ��� �������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# ���������� �� ��������� ��������� ����� �� ���������
		[Switch]
		$PassThru
	)

	try {
		$Params = @{};
		foreach ( $param in 'Server') {
			if ( $PSBoundParameters.ContainsKey( $param ) ) {
				$Params.Add( $param,  $PSBoundParameters.$param );
			};
		};
		$Config = Get-DomainUtilsConfiguration `
			-Domain $Domain `
			@Params `
		;
		New-ADObject `
			-Type ( $Config.ContainerClass ) `
			-Path ( $Config.DomainUtilsBase ) `
			-Name ( $Config.PrintQueuesContainerName ) `
			-Description ( $loc.PrintQueuesContainerDescription ) `
			-ProtectedFromAccidentalDeletion $true `
			-PassThru:$PassThru `
			-Verbose:$VerbosePreference `
			@Params `
		;
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

Function New-ADPrintQueueGroup {
<#
.Synopsis
	������ ������ ������������ ��� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueGroup ������ ������ ������������
	(������������ ��������, ��������� ��������) ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	���������� ��������� ������ ������������ ��� ���������� � ������ PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGroup
.Link
	New-ADObject
.Link
	New-ADGroup
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueGroup
	������ ������ ������������ ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGroup -GroupType Users
	������ ������ ������������ "������������ ��������" ��� ���� ������������
	�������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGroup'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# ��� ������: Users (������ �������������), Administrators (������ ���������������).
		# ������ ������������� ������� ����� ���������� ��������� �������� ��� ���� ������� ������, � ����� ������.
		# ������ ��������������� �� ������� ����� ���������� GPO, �� ������� ����� ������ � ����� ���������� ����� �����������
		# � ��������� ������� ������.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = ( 'Users', 'Administrators' )
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# ���������� �� ��������� ������ ����� �� ���������
		[Switch]
		$PassThru
	)

	process {
		try {
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			foreach ( $SingleGroupType in $GroupType ) {
				try {
					New-ADGroup `
						-Path ( $Config.PrintQueuesContainer ) `
						-Name ( [String]::Format( $Config."printQueue$( $SingleGroupType )Group", $InputObject.PrinterName ) ) `
						-SamAccountName ( [String]::Format(
							$Config."printQueue$( $SingleGroupType )GroupAccountName"
							, $InputObject.PrinterName
							, $InputObject.ServerName
							, $InputObject.Name
						) ) `
						-GroupCategory Security `
						-GroupScope DomainLocal `
						-Description ( [String]::Format(
							$loc."printQueue$( $SingleGroupType )GroupDescription"
							, $InputObject.PrinterName
							, $InputObject.ServerName
							, $InputObject.Name
							, $InputObject.PrintShareName
						) ) `
						-OtherAttributes @{
							info = ( [String]::Format(
								$loc."printQueue$( $SingleGroupType )GroupInfo"
								, $InputObject.PrinterName
								, $InputObject.ServerName
								, $InputObject.Name
								, $InputObject.PrintShareName
							) );
						} `
						@Params `
						-Verbose:$VerbosePreference `
						-PassThru:$PassThru `
					;
				} catch {
					Write-Error `
						-ErrorRecord $_ `
					;
				};
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterGroup -Value New-ADPrintQueueGroup -Force;

Function Get-ADPrintQueueGroup {
<#
.Synopsis
	���������� ������������� ������ ������������ ��� ���������� ������� printQueue. 
.Description
	Get-ADPrintQueueGroup ���������� ������ ������������
	(������������ ��������, ��������� ��������) ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	���������� ������������� ������ ������������.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGroup
.Link
	Get-ADObject
.Link
	Get-ADGroup
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueGroup -GroupType Users
	���������� ������ ������������ ������������ �������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGroup'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# ��� ������: Users (������ �������������), Administrators (������ ���������������).
		# ������ ������������� ������� ����� ���������� ��������� �������� ��� ���� ������� ������, � ����� ������.
		# ������ ��������������� �� ������� ����� ���������� GPO, �� ������� ����� ������ � ����� ���������� ����� �����������
		# � ��������� ������� ������.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = 'Users'
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		try {
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			foreach ( $SingleGroupType in $GroupType ) {
				try {
					Get-ADGroup `
						-Identity "CN=$( [String]::Format( $Config."printQueue$( $SingleGroupType )Group", $InputObject.PrinterName ) ),$( $Config.PrintQueuesContainer )" `
 						@Params `
					;
				} catch {
					Write-Error `
						-ErrorRecord $_ `
					;
				};
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinterGroup -Value Get-ADPrintQueueGroup -Force;

Function New-ADPrintQueueGPO {
<#
.Synopsis
	������ ��������� ��������, ����������� � ������������� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueGPO ������ ������ ��������� �������� ��� "�����������" ������
	������ ������������ �������� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.GroupPolicy.Gpo
	���������� ��������� ��������� �������� ��� ���������� � ������ PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO
.Link
	New-GPO
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueGPO
	������ ������ ��������� �������� ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGPO -Force
	������ ��������� �������� ��� ���� ������������
	�������� ������ ���� ��������� �� (���� GPO ����������).
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# ��������� �� ������������ ������� GPO
		[Switch]
		$Force
	,
		# ������������� �� ������� ��� ������� �� ��������� ��� ���������� ��������� ���������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		[ValidateSet(
			'DefaultPrinterWhenNoLocalPrintersPresent'
			, 'DefaultPrinter'
			, 'DontChangeDefaultPrinter'
		)]
		[Alias( 'Default' )]
		$DefaultPrinterSelectionMode = 'DefaultPrinterWhenNoLocalPrintersPresent'
	,
		# �������������� ������������ ������� � ��������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Port = ''
	,
		# ������������� �� ����������� � �������� ��� ����������. � ���� ������ ���� ��� ������������� ���������� ��������� ������� ��� ��������
		# ������� ����� �������� �������������. � ��������� ������ ������� ����� ������������ ������ ����� ���������� ��������� ������� � ������ � ������
		# ����������� ���������� ��������� �������.
		[Switch]
		$AsPersistent
	,
		# ���������� �� ��������� GPO ����� �� ���������
		[Switch]
		$PassThru
	)

	process {
		try {
			if ( -not  $Server ) {
				$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
			};
			$ADDomain = Get-ADDomain `
				-Identity $Domain `
				-Server $Server `
			;
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				-Server $Server `
			;
			switch ( $DefaultPrinterSelectionMode ) {
				'DefaultPrinterWhenNoLocalPrintersPresent' {
					$AsDefault = $true;
					$AsDefaultAlways = $false;
				}
				'DefaultPrinter' {
					$AsDefault = $true;
					$AsDefaultAlways = $true;
				}
				'DontChangeDefaultPrinter' {
					$AsDefault = $false;
					$AsDefaultAlways = $false;
				}
			};
			[Microsoft.GroupPolicy.Gpo] $GPO = New-GPO `
				-Domain $Domain `
				-Name ( [String]::Format(
					$Config.printQueueGPOName
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
				) ) `
				-Comment ( [String]::Format(
					$loc.printQueueGPOComment
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
					, $InputObject.PrintShareName
				) ) `
				-Server $Server `
				-Verbose:$VerbosePreference `
			;
			$PrintQueueUsersGroup =	Get-ADPrintQueueGroup `
				-InputObject $InputObject `
				-GroupType Users `
				-Domain $Domain `
				-Server $Server `
			;
			if ( $GPO ) { 
				try { 
					$GPO `
					| Set-GPPermission `
						-PermissionLevel GpoApply `
						-Replace `
						-TargetType Group `
						-TargetName ( $PrintQueueUsersGroup.SamAccountName ) `
						-Server $Server `
					| Set-GPPermission `
						-PermissionLevel GpoRead `
						-TargetType Group `
						-TargetName ( $PrintQueueUsersGroup.SamAccountName ) `
						-Server $Server `
					| Set-GPPermission `
						-PermissionLevel GpoRead `
						-Replace `
						-TargetType Group `
						-TargetName ( ( [System.Security.Principal.SecurityIdentifier] 'S-1-5-11' ).Translate( [System.Security.Principal.NTAccount] ).Value ) `
						-Server $Server `
					| Out-Null `
					;
					$GPOFilePartPath = (
						Get-ADObject `
							-Identity ( "CN=$( $GPO.Id.ToString( 'B' ).ToUpperInvariant() ),CN=Policies,CN=System,$( $ADDomain.DistinguishedName )" ) `
							-Properties `
								gPCFileSysPath `
							-ErrorAction Stop `
							-Server $Server `
					).gPCFileSysPath;
					$GPO.Computer.Enabled = $false;
					$GPO.User.Enabled = $true;
					$FilePartDir = "$GPOFilePartPath\User\Preferences\Printers";
					$FilePartPath = "$FilePartDir\Printers.xml";
					$null = [System.IO.Directory]::CreateDirectory( $FilePartDir );

					[xml] $PrintersDoc = @"
<?xml version="1.0" encoding="utf-8"?>
<Printers clsid="{1F577D12-3D1B-471E-A1B7-060317597B9C}">
	<SharedPrinter
		clsid="{9A5E9697-9095-436D-A0EE-4D128FDFBCE5}"
		name="$( $InputObject.PrinterName )"
		status="$( [String]::Format(
			$loc.PrintQueueGPPStatus
			, $InputObject.PrinterName
			, $InputObject.ServerName
			, $InputObject.Name
			, $InputObject.PrintShareName
		) )"
		desc="$( [String]::Format(
			$loc.printQueueGPPComment
			, $InputObject.PrinterName
			, $InputObject.ServerName
			, $InputObject.Name
			, $InputObject.PrintShareName
		) )"
		image="1"
		changed="$( Get-Date -Format ( ( Get-Culture ).DateTimeFormat.UniversalSortableDateTimePattern ) )"
		uid="{FB9C0A41-67DC-4ED4-B305-A9B8CEB0EA73}"
		removePolicy="1"
		userContext="1"
		bypassErrors="1"
	>
		<Properties
			action="R"
			comment="$( [String]::Format(
				$loc.printQueueGPPComment
				, $InputObject.PrinterName
				, $InputObject.ServerName
				, $InputObject.Name
				, $InputObject.PrintShareName
			) )"
			deleteMaps="0"
			path="$( $InputObject.uNCName )"
			location="$( $InputObject.location )"
			default="$( [int] $AsDefault )"
			skipLocal="$( [int] ( -not $AsDefaultAlways ) )"
			persistent="$( [int] [bool] $AsPersistent )"
			deleteAll="0"
			port="$( $Port )"
		/>
	</SharedPrinter>
</Printers>
"@
					$Writer = [System.Xml.XmlWriter]::Create(
						$FilePartPath `
						, ( New-Object `
							-TypeName System.Xml.XmlWriterSettings `
							-Property @{
								Indent = $true;
								OmitXmlDeclaration = $false;
								NamespaceHandling = [System.Xml.NamespaceHandling]::OmitDuplicates;
								NewLineOnAttributes = $true;
								CloseOutput = $true;
								IndentChars = "`t";
							} `
						) `
					);
					$PrintersDoc.WriteTo( $Writer );
					$Writer.Close();
				} catch {
					Remove-GPO `
						-Guid ( $GPO.Id ) `
						-Server $Server `
						-ErrorAction Continue `
					;
					throw;
				};

				if ( $PassThru ) { return $GPO; };
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterGPO -Value New-ADPrintQueueGPO -Force;

Function Get-ADPrintQueueGPO {
<#
.Synopsis
	���������� ������ ��������� ��������, ����������� � ������������� ���������� ������� printQueue. 
.Description
	���������� ������ ��������� ��������, ��������� ��� "�����������" ������
	������ ������������ �������� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.GroupPolicy.Gpo
	���������� ������ ��������� �������� ��� ��������� ������� ������
	���� ���������� ������.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGPO
.Link
	Get-ADPrintQueueGPO
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueGPO
	���������� ������ ��������� �������� ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | Get-ADPrintQueueGPO | Remove-GPO -Verbose
	������� ��������� �������� ��� ���� ������������
	�������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $false
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGPO'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		try {
			if ( -not  $Server ) {
				$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
			};
			$ADDomain = Get-ADDomain `
				-Identity $Domain `
				-Server $Server `
			;
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				-Server $Server `
			;
			return ( Get-GPO `
				-Domain $Domain `
				-Name ( [String]::Format(
					$Config.printQueueGPOName
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
				) ) `
				-Server $Server `
			);
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinterGPO -Value Get-ADPrintQueueGPO -Force;

Function Test-ADPrintQueueGPO {
<#
.Synopsis
	��������� ������� ������� ��������� ��������, ����������� � ������������� ���������� ������� printQueue. 
.Description
	���������� `$true` ��� `$false`, �������� ������� ���� ���������� ������� ��������� �������� ��� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Bool
	������������ ��� ����������� ���� ������� ������� ��������� �������� ��� ��������� ������� ������.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueGPO
.Link
	Test-ADPrintQueueGPO
.Link
	Get-ADPrintQueueGPO
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Test-ADPrintQueueGPO
	��������� ������� GPO ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | ? { -not ( $_ | Test-ADPrintQueueGPO ) } | New-ADPrintQueueGPO -Verbose
	������ ����������� ������� �������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $false
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueGPO'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		try {
			foreach ( $param in 'ErrorAction' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			return [bool] ( Get-ADPrintQueueGPO `
				@PSBoundParameters `
				-ErrorAction SilentlyContinue `
			).Count;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Test-ADPrinterGPO -Value Test-ADPrintQueueGPO -Force;

Function Update-ADPrintQueueEnvironment {
<#
.Synopsis
	������ (��� ����������) ������ ������������ � ������ GPO.
.Description
	������ (��� ����������) ������ ������������ � ������ GPO ��� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Update-ADPrintQueueEnvironment
.Link
	New-ADPrintQueueGPO
.Link
	New-ADPrintQueueGroup
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue | Update-ADPrintQueueEnvironment -Verbose
	������ (��� ����������) ������ ������������ � ������ GPO ��� ����
	�������� ������
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Update-ADPrintQueueEnvironment'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# ������������� �� ������� ��� ������� �� ��������� ��� ���������� ��������� ���������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		[ValidateSet(
			'DefaultPrinterWhenNoLocalPrintersPresent'
			, 'DefaultPrinter'
			, 'DontChangeDefaultPrinter'
		)]
		[Alias( 'Default' )]
		$DefaultPrinterSelectionMode = 'DefaultPrinterWhenNoLocalPrintersPresent'
	,
		# �������������� ������������ ������� � ��������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Port = ''
	,
		# ������������� �� ����������� � �������� ��� ����������. � ���� ������ ���� ��� ������������� ���������� ��������� ������� ��� ��������
		# ������� ����� �������� �������������. � ��������� ������ ������� ����� ������������ ������ ����� ���������� ��������� ������� � ������ � ������
		# ����������� ���������� ��������� �������.
		[Switch]
		$AsPersistent
	)

	process {
		try {
			if ( -not  $Server ) {
				$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
			};
			$ADDomain = Get-ADDomain `
				-Identity $Domain `
				-Server $Server `
			;
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				-Server $Server `
			;
			$Users = Get-ADPrintQueueGroup `
				-InputObject $InputObject `
				-GroupType Users `
				-Domain $Domain `
				-Server $Server `
				-ErrorAction SilentlyContinue `
			;
			if ( -not $Users ) {
				$Users = New-ADPrintQueueGroup `
					-InputObject $InputObject `
					-GroupType Users `
					-Domain $Domain `
					-Server $Server `
					-PassThru `
					-Verbose:$VerbosePreference `
				;
			};
			$Admins = Get-ADPrintQueueGroup `
				-InputObject $InputObject `
				-GroupType Administrators `
				-Domain $Domain `
				-Server $Server `
				-ErrorAction SilentlyContinue `
			;
			if ( -not $Admins ) {
				$Admins = New-ADPrintQueueGroup `
					-InputObject $InputObject `
					-GroupType Administrators `
					-Domain $Domain `
					-Server $Server `
					-PassThru `
					-Verbose:$VerbosePreference `
				;
			};
			if ( -not ( Test-ADPrintQueueGPO `
				-InputObject $InputObject `
				-Domain $Domain `
				-Server $Server `
			) ) {
				New-ADPrintQueueGPO `
					-InputObject $InputObject `
					-Domain $Domain `
					-Server $Server `
					-DefaultPrinterSelectionMode $DefaultPrinterSelectionMode `
					-Port $Port `
					-AsPersistent:$AsPersistent `
					-Verbose:$VerbosePreference `
				;
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Update-ADPrinterEnvironment -Value Update-ADPrintQueueEnvironment -Force;

Function Remove-ADPrintQueueEnvironment {
<#
.Synopsis
	������� ������ ������������ � ������ GPO ��� ��������� ������� ������.
.Description
	������� ������ ������������ � ������ GPO ��� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Remove-ADPrintQueueEnvironment
.Link
	Update-ADPrintQueueEnvironment
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue | Remove-ADPrintQueueEnvironment -Verbose
	������� ������ ������������ � ������� GPO ��� ����
	�������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'High'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Remove-ADPrintQueueEnvironment'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		try {
			if ( -not  $Server ) {
				$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
			};
			$ADDomain = Get-ADDomain `
				-Identity $Domain `
				-Server $Server `
			;
			$InputObject `
			| Get-ADPrinterGPO `
				-Domain $Domain `
				-Server $Server `
				-ErrorAction SilentlyContinue `
			| Remove-GPO `
				-Domain $Domain `
				-Server $Server `
				-Verbose:$VerbosePreference `
			;
			$InputObject `
			| Get-ADPrintQueueGroup `
				-GroupType Administrators, Users `
				-Domain $Domain `
				-Server $Server `
				-ErrorAction SilentlyContinue `
			| Remove-ADGroup `
				-Server $Server `
				-Verbose:$VerbosePreference `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Remove-ADPrinterEnvironment -Value Remove-ADPrintQueueEnvironment -Force;
