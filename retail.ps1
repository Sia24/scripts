$paths = @(
    "C:\Windows\Microsoft.NET\Framework\v2.0.50727\Config\",
    "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\",
    "C:\Windows\Microsoft.NET\Framework64\v2.0.50727\Config",
    "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\"
)

foreach ($path in $paths)
{
    if (Test-Path $path)
    {
        Write-Host "`n=== Scanning $path ===" -ForegroundColor Cyan

        Get-ChildItem -Path $path -Filter "*.config" -File | ForEach-Object {
            Write-Host "Processing file: $($_.FullName)" -ForegroundColor Green

            try {
                [xml]$xml = Get-Content $_.FullName -ErrorAction Stop

                $deploymentNodes = $xml.SelectNodes("//deployment")

                foreach ($node in $deploymentNodes)
                {
                    $retailValue = $node.retail

                    Write-Host "File: $($_.FullName)"
                    Write-Host "Retail value: $retailValue"
                    Write-Host "-----------------------------------"
                }
            }
            catch {
                Write-Warning "Unable to parse XML: $($_.FullName)"
            }
        }
        else {
            Write-Warning "No .config files found in $path"
        }
    }
    else
    {
        Write-Warning "$path not found"
    }
}
