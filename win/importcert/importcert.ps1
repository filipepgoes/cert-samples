if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
$FileName = "$pwd\gcert.cer"
if (Test-Path $FileName) 
{
  Remove-Item $FileName
}
$webRequest = [Net.WebRequest]::Create("https://dados.paas.previc.gov")
try { $webRequest.GetResponse() } catch {}
$cert = $webRequest.ServicePoint.Certificate
$bytes = $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)
set-content -value $bytes -encoding byte -path $FileName
keytool -import -alias dados -file $FileName -keystore $env:JAVA_HOME/lib/security/cacerts -storepass changeit -trustcacerts
