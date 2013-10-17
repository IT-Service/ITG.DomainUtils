$printQueuesContainerName = 'printQueues';

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
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
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
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
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

Function Install-ADPrintQueuesEnvironment {
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
	https://github.com/IT-Service/ITG.DomainUtils#Install-ADPrintQueuesEnvironment
.Link
	Get-ADObject
.Example
	Install-ADPrintQueuesEnvironment
	������ �������� ��������� � ����������� �� ���������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Install-ADPrintQueuesEnvironment'
	)]

	param (
		# ���� � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = "$( ( Get-ADDomain ).DistinguishedName )"
	,
		# ��� (displayName) ����������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerDisplayName = ( $loc.PrintQueuesContainerName )
	,
		# ����� ����������, ������������ ��� ������� ��������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# �������� ����������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Description = ( $loc.PrintQueuesContainerDescription )
	,
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
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
		foreach ( $param in 'DomainUtilsBase', 'ContainerClass', 'ContainerDisplayName', 'Description' ) {
			$null = $PSBoundParameters.Remove( $param );
		};
		New-ADObject `
			-Type $ContainerClass `
			-Path $DomainUtilsBase `
			-Name $printQueuesContainerName `
			-Description $Description `
			-DisplayName $ContainerDisplayName `
			-ProtectedFromAccidentalDeletion $true `
			@PSBoundParameters `
		;
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

Function Get-ADPrintQueueContainer {
<#
.Synopsis
	���������� ��������� AD ��� ������� printQueue. 
.Description
	Get-ADPrintQueueContainer ���������� ������ ���������� ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
	���� ������ �� ������, ����� ���������� ��� ���������� ��������� ��� �������� ������.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ��������� ��� ���������� ������� ������ printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueContainer
	���������� ��������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $false
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
		# �������� ������� ������� ���������� ��� ������� �� ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties
	,
		# ���� � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# ����� ����������, ������������ ��� ������� ��������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
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
			foreach ( $param in 'PrinterName', 'InputObject', 'DomainUtilsBase', 'ContainerClass' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			$Filter = "( objectClass -eq '$ContainerClass' )";
			if ( $InputObject ) {
				$Filter += " -and ( name -eq '$( $InputObject.PrinterName )'  )";
			};
			Get-ADObject `
				-Filter $Filter `
				-SearchBase "CN=$printQueuesContainerName,$DomainUtilsBase" `
				-SearchScope ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::OneLevel ) `
				@PSBoundParameters `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinterContainer -Value Get-ADPrintQueueContainer -Force;

Function Test-ADPrintQueueContainer {
<#
.Synopsis
	��������� ������� ���������� AD ��� ���������� ������� printQueue. 
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	bool
	������ - �������, ��������������� ��������� ������������, ����������;
	���� - �� ����������
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer
.Link
	Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Test-ADPrintQueueContainer
	��������� ������� ���������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $false
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
		# ���� � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# ����� ����������, ������������ ��� ������� ��������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		[bool] ( Get-ADPrintQueueContainer @PSBoundParameters );
	}
}

New-Alias -Name Test-ADPrinterContainer -Value Test-ADPrintQueueContainer -Force;

Function New-ADPrintQueueContainer {
<#
.Synopsis
	������ ��������� AD ��� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueContainer ������ ������ ���������� ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ��������� ��� ���������� ������� ������ printQueue
	��� ���������� � ������ PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer
.Link
	New-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueContainer
	������ ��������� ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueContainer -PassThru | % { do-something }
	������ ���������� ��� ���� �������� ������, ���� ��� �� ���������,
	� ��������� ��� ������� ���������� �� ���� ���� ��������.
	���� ��������� ��� ����������, �� �� ��������� � �� ������������, � ��������������
	�������� ��� ���� ��������� �� �����.
.Example
	Get-ADPrintQueue | ? { -not ( Test-ADPrintQueueContainer $_ ) } | New-ADPrintQueueContainer -Confirm
	������ ������ ������������� ���������� ��� ���� ������������������ � AD �������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer'
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
		# ���� � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# ����� ����������, ������������ ��� ������� ��������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# �������� ����������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Description = ( $loc.PrintQueueContainerDescription )
	,
		# ����� ��������������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# ������� ������ ��� ���������� ������ ��������
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
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

	process {
		try {
			foreach ( $param in 'InputObject', 'DomainUtilsBase', 'ContainerClass', 'Description' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			New-ADObject `
				-Type $ContainerClass `
				-Path "CN=$printQueuesContainerName,$DomainUtilsBase" `
				-Name $InputObject.PrinterName `
				-Description ( [String]::Format(
					$Description
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.PrintShareName
				) ) `
				@PSBoundParameters `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterContainer -Value New-ADPrintQueueContainer -Force;
