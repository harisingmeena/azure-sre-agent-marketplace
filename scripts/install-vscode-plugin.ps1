$ErrorActionPreference = 'Stop'

$marketplace = [uri]::EscapeDataString('harisingmeena/azure-sre-agent-marketplace')
$plugin = [uri]::EscapeDataString('azure-appservice-sre')
$installUri = "vscode://chat-plugin/install?source=$marketplace&plugin=$plugin"

try {
    Start-Process -FilePath $installUri
    Write-Host 'VS Code was asked to install the Azure SRE plugin.'
    Write-Host 'Review the marketplace and plugin, then confirm the prompts in VS Code.'
}
catch {
    Write-Error "Could not open the VS Code install link. Confirm VS Code is installed and the vscode:// protocol is registered. You can also open this link manually: $installUri"
    exit 1
}
