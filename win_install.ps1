param (
  [switch]$tools,
  [switch]$font,
  [switch]$nvim,
  [switch]$python,
  [switch]$zip7,
  [switch]$kdiff3,
  [switch]$sourcegit,
  [switch]$chrome,
  [switch]$monitor,
  [switch]$notepad,
  [switch]$vsc,
  [switch]$vs,
  [switch]$vcredist,
  [switch]$reg,
  [switch]$help,
  [switch]$all
)

# Set the execution policy to Unrestricted
Set-ExecutionPolicy Unrestricted -Scope Process -Force


# If --all is specified, set all other parameters to true
if ($all) {
  $tools     = $true
  $font      = $true
  $nvim      = $true
  $python    = $true
  $zip7      = $true
  $kdiff3    = $true
  $sourcegit = $true
  $chrome    = $true
  $monitor   = $true
  $notepad   = $true
  $vsc       = $true
  $vs        = $true
  $vcredist  = $true
  $reg       = $true
}

# If -help or no parameters are specified, print the help message
if (
  $help -or
  (
    $tools     -eq $false -and
    $font      -eq $false -and
    $nvim      -eq $false -and
    $python    -eq $false -and
    $zip7      -eq $false -and
    $kdiff3    -eq $false -and
    $sourcegit -eq $false -and
    $chrome    -eq $false -and
    $monitor   -eq $false -and
    $notepad   -eq $false -and
    $vsc       -eq $false -and
    $vs        -eq $false -and
    $vcredist  -eq $false -and
    $reg       -eq $false -and
    $all       -eq $false
  )
) {
  # Define the parameters
  $parameters = @(
      "-tools",
      "-font",
      "-nvim",
      "-python",
      "-zip7",
      "-kdiff3",
      "-sourcegit",
      "-chrome",
      "-monitor",
      "-notepad",
      "-vsc",
      "-vs",
      "-vcredist",
      "-reg",
      "-help",
      "-all"
  )

  # Format the parameters with square brackets
  $formattedParameters = $parameters | ForEach-Object { "[$_]" }

  # Get the current running file name
  $currentFileName = Split-Path -Leaf $PSCommandPath
  # Build the usage string
  $usage = "Usage: .\$currentFileName " + ($formattedParameters -join " ")

  Write-Host $usage -ForegroundColor Green
  Write-Output ""

  Write-Output "Options:"
  Write-Output ""
  Write-Output "  -tools      Install the following tools through Scoop(https://scoop.sh/#/apps): "
  Write-Output "              everything, alacritty, handbrake, lazygit, mkcert, posh-git, cmder-full,"
  Write-Output "              neovim@0.9.5, yarn, nvm, wget, ripgrep, fzf, make, cmake, gcc, sysinternals-suite"
  Write-Output ""
  Write-Output "  -font       Install the following developer-friendly Nerd Mono fonts: "
  Write-Output "              Hack, Agave, Meslo, FiraCode, Inconsolata, CascadiaMono, JetBrainsMono, DejaVuSansMono"
  Write-Output ""
  Write-Output "  -nvim       Configure for the neovim and alacritty"
  Write-Output "  -python     Install Python"
  Write-Output "  -zip7       Install 7-zip"
  Write-Output "  -kdiff3     Install KDiff3 and configure it for git"
  Write-Output "  -sourcegit  Install SourceGit, a GUI client for git"
  Write-Output "  -chrome     Install Google Chrome browser"
  Write-Output "  -monitor    Install and Configure Traffic Monitor & LibreHardwareMonitor"
  Write-Output "  -notepad    Install and Configure Notepad Next, a cross-platform Open-Source text editor"
  Write-Output "  -vsc        Install Visual Studio Code"
  Write-Output "  -vs         Install Visual Studio"
  Write-Output "  -vcredist   Install vcredist 2005~2023"
  Write-Output "  -reg        Update the registry, e.g. restore the context menu, etc."
  Write-Output "  -all        Install all above"
  Write-Output "  -help       Print this help message"
  return
}

# Capture the start time
$startTime = Get-Date

# define global variables
$env:logs_dir = "C:\logs"

# Check if the logs directory exists and create it if it doesn't
if (-not (Test-Path -Path $env:logs_dir)) {
  New-Item -ItemType Directory -Force -Path $env:logs_dir | Out-Null
}
# Check if the temp folder exists and create it if it doesn't
if (-not (Test-Path -Path $env:TEMP)) {
  New-Item -ItemType Directory -Force -Path $env:TEMP | Out-Null
}
function getProgramsAndFeatures() {
  # get from the control panel -> programs and features
  return Get-WmiObject -Class Win32_Product | Select-Object -Property Name
}
function getUninstallablePrograms() {
  # get from the registry
  Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName
}
function CheckOnUninstallablePrograms($programList, $programName) {
  foreach ($program in $programList) {
    if ($program.DisplayName -like "*$programName*") {
      return $true
    }
  }
  return $false
}
function CheckOnProgramsAndFeatures($programList, $programName) {
  foreach ($program in $programList) {
    if ($program.Name -like "*$programName*") {
      return $true
    }
  }
  return $false
}

# Write-Host "Listing uninstallable Programs..."
$uninstallablePrograms = getUninstallablePrograms
# Write-Output $uninstallablePrograms

# Write-Host "Listing installed Programs and Features..."
# $installedProgramsAndFeatures = getProgramsAndFeatures
# Write-Output $installedProgramsAndFeatures

# Define the function to install packages
function InstallPackage {
  param (
    [Parameter(Mandatory)]
    [string]$packageName
  )

  # Check if packageName contains a '/'
  if ($packageName -like "*/*") {
    # Split packageName into bucket and name
    $bucket, $name = $packageName -split '/', 2
  }
  else {
    $name = $packageName
  }

  Write-Host -NoNewline "Checking for "
  Write-Host -NoNewline -ForegroundColor Yellow $name
  Write-Host " installation..."

  if (!(scoop list $name | Select-String -Pattern $name)) {
    Write-Host -NoNewline -ForegroundColor Yellow "$name"
    Write-Host " not found. Installing..."
    scoop install $packageName
  }
  else {
    Write-Host -NoNewline -ForegroundColor Green "$name"
    Write-Host " is already installed."
  }
}

# Define the function to install buckets
function InstallBucket {
  param (
    [Parameter(Mandatory)]
    [string]$bucketName
  )
  Write-Host -NoNewline "Checking for "
  Write-Host -NoNewline -ForegroundColor Yellow $bucketName
  Write-Host " bucket..."
  if (!(scoop bucket list | Select-String -Pattern $bucketName)) {
    Write-Host -NoNewline -ForegroundColor Yellow $bucketName
    Write-Host " bucket not found. Adding..."
    scoop bucket add $bucketName
  }
  else {
    Write-Host -ForegroundColor Green "$bucketName bucket is already added."
  }
}

function New-Shortcut {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ShortcutName,
        
        [Parameter(Mandatory=$true)]
        [string]$TargetPath,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Desktop", "StartMenu")]
        [string]$Location = "Desktop"
    )

    # Determine the path based on the location
    switch ($Location) {
        "Desktop" {
            $shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "$ShortcutName.lnk")
        }
        "StartMenu" {
            $startMenuPath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs")
            $shortcutPath = [System.IO.Path]::Combine($startMenuPath, "$ShortcutName.lnk")
        }
    }

    # Create the shortcut if it doesn't already exist
    if (-Not (Test-Path $shortcutPath)) {
        $WScriptShell = New-Object -ComObject WScript.Shell
        $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $TargetPath
        $shortcut.Save()
        Write-Host "Created shortcut '$ShortcutName' in $Location"
    } else {
        Write-Host "Shortcut '$ShortcutName' already exists in $Location"
    }

    return $shortcutPath
}

# download from url by using Invoke-WebRequest
function Invoke-From-Url {
  param (
    [Parameter(Mandatory)]
    [string]$Url,

    [Parameter()]
    [string]$DownloadFolder = $env:TEMP,

    [Parameter()]
    [string]$FileName
  )

  # If FileName is not provided, parse the file name from the url
  if (-not $FileName) {
    $FileName = Split-Path $Url -Leaf
  }

  # Set the destination path in the specified download folder
  $destinationPath = Join-Path $DownloadFolder $FileName

  # Check if the file already exists
  if (-Not (Test-Path $destinationPath)) {
    # Try to download the file
    try {
      Write-Host "Downloading $FileName ..."
      Invoke-WebRequest -Uri $Url -OutFile $destinationPath
      Write-Host "File downloaded successfully to $destinationPath"
      return $destinationPath
    }
    catch {
      # Throw an exception if download failed
      Write-Host "ERROR: Failed to download the file from $Url"
      throw "Failed to download the file from $Url"
    }
  }
  else {
    Write-Host "File already exists at $destinationPath"
    return $destinationPath
  }
}

# download from url by using curl
function Get-By-Curl {
  param (
    [Parameter(Mandatory)]
    [string]$Url,

    [Parameter()]
    [string]$FileName,

    [Parameter()]
    [string]$DownloadFolder = $env:TEMP
  )

  # If FileName is not provided, parse the file name from the url
  if (-not $FileName) {
    $FileName = Split-Path $Url -Leaf
  }

  # Set the destination path in the specified download folder
  $destinationPath = Join-Path $DownloadFolder $FileName

  # Check if the file already exists
  if (-Not (Test-Path $destinationPath)) {
    # Try to download the file
    try {
      Write-Host "Downloading $FileName ..."
      $Arguments = "-L", $Url, "-o", $destinationPath
      Start-Process -NoNewWindow -FilePath "curl" -ArgumentList $Arguments -Wait
      Write-Host "File downloaded successfully to $destinationPath"
      return $destinationPath
    }
    catch {
      # Throw an exception if download failed
      Write-Host "ERROR: Failed to download the file from $Url"
      throw "Failed to download the file from $Url"
    }
  }
  else {
    Write-Host "File already exists at $destinationPath"
    return $destinationPath
  }
}

function Test-Install {
  param (
    [Parameter(Mandatory)]
    [string]$FilePath,

    # if the extension of the $FilePath is .zip, the $InstallArgs is the destination path
    # if the extension of the $FilePath is .exe, the $InstallArgs is the arguments for the installation
    [Parameter()]
    [string]$InstallArgs = '/S',

    [Parameter()]
    [string]$TargetFile
  )

  # If the target file exists, try to install or extract it
  if ($TargetFile) {
    if (Test-Path $TargetFile) {
      Write-Host "Target file $TargetFile already exists"
      return
    }
  }

  # Check if the source file exists
  if (Test-Path $FilePath) {
    # If the source file exists, try to install it
    try {
      $name = Split-Path $FilePath -Leaf
      $extension = [System.IO.Path]::GetExtension($name)

      if ($extension -eq ".exe") {
        Write-Host "Installing $name ..."
        Start-Process -FilePath $FilePath -Wait -ArgumentList $InstallArgs -NoNewWindow -PassThru
        Write-Host "$name installation succeeded"
      }
      elseif ($extension -eq ".zip") {
        Write-Host "Extracting $name to $InstallArgs ..."
        Expand-Archive -Path $FilePath -DestinationPath $InstallArgs -Force
        Write-Host "$name extraction succeeded"
      }
      else {
        Write-Host "ERROR: Unsupported file extension $extension"
        throw "Unsupported file extension $extension"
      }
    }
    catch {
      # Throw an exception if installation failed
      Write-Host "ERROR: Failed to install the file from $FilePath"
      throw "Failed to install the file from $FilePath"
    }
  }
  else {
    # Throw an exception if the source file does not exist
    Write-Host "ERROR: Source file $FilePath not found"
    throw "Source file $FilePath not found"
  }
}

function Install-Git {
  $gitClient_dst = "C:\Program Files\Git\cmd\git.exe"
  if (-Not (Test-Path $gitClient_dst)) {
    $gitClient_url = "https://github.com/git-for-windows/git/releases/download/v2.37.2.windows.2/Git-2.37.2.2-64-bit.exe"
    $gitClient_src = Get-By-Curl -Url $gitClient_url
    $installerArgs = "/VERYSILENT /NORESTART /DIR=`"C:\Program Files\Git`""
    Test-Install -FilePath $gitClient_src -TargetFile $gitClient_dst -InstallArgs $installerArgs
  } else {
    Write-Host "git.exe exists at $gitClient_dst"
  }
}

function Install-Python {
  param (
    [Parameter(Mandatory)]
    [string]$Name,
    [Parameter(Mandatory)]
    [string]$python_dir
  )
  $Arguments = "/quiet", "InstallAllUsers=1", "PrependPath=1", "/log", "`"${env:logs_dir}\python.log`"", "`"TargetDir=$python_dir`""
  $proc = Start-Process $Name -Wait -ArgumentList $Arguments -PassThru
  if ($proc.ExitCode -ne 0) {
    Write-Host "ERROR: python installation failed with return code: $($proc.ExitCode)"
    Write-Host "Python installation logs below:"
    Get-Content "${env:logs_dir}\python.log"
    throw "Python installation failed"
  }
  Get-ChildItem -Path "$python_dir"
  New-Item -Path "$python_dir\python3.exe" -ItemType SymbolicLink -Value "$python_dir\python.exe"
  New-Item -Path "$python_dir\pythonw3.exe" -ItemType SymbolicLink -Value "$python_dir\pythonw.exe"
  Start-Process -FilePath "$python_dir\python3.exe" -Wait -ArgumentList "-m pip install -U pip setuptools" -PassThru
  Start-Process -FilePath "$python_dir\scripts\pip3.exe" -Wait -ArgumentList "install virtualenv" -PassThru
}


# By default, the "Scoop" will always be installed
# Start Scoop Installation
Write-Host "Checking for Scoop installation..."
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
  Write-Host "Scoop not found. Installing Scoop..."
  # iwr -useb get.scoop.sh | iex

  # if you current logon user is a Administrator, please try to install the scoop by the following command
  # and then re-run the current powershell script, refer to: https://github.com/ScoopInstaller/Install
  Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
}
else {
  Write-Host "Scoop is already installed."
}

# Check and install a portable 'git', which is a prerequisite for the following installation
InstallPackage -packageName 'git'

# using the git manager to manage the related credentials
# git config --global credential.helper wincred

# Check if buckets 'extras', 'nerd-fonts', and 'sysinternals' exist and install them if not
$bucketArray = @('extras', 'nerd-fonts', 'sysinternals')
foreach ($bucket in $bucketArray) {
  InstallBucket -bucketName $bucket
}
# End Scoop Installation


if ($vcredist) {
  # Install vcredist from Scoop
  $vcArray = @(
    'extras/vcredist2005', # install vcredist 2005, 2008, 2010, 2012, 2013.
    'extras/vcredist2008',
    'extras/vcredist2010',
    'extras/vcredist2012',
    'extras/vcredist2013',
    'extras/vcredist2022' # including vcredist 2015, 2017, 2019, and 2022
  )

  foreach ($app in $vcArray) {
    # Call the function to check and install each app
    InstallPackage -packageName $app
  }
}

if ($tools) {
  # Install software(s) from Scoop
  $appArray = @(
    # tools with GUI
    'extras/everything', # A tool to locate files and folders by name instantly.
    'extras/alacritty', # A GPU-accelerated terminal emulator
    'extras/handbrake', # A tool for converting video from nearly any format to a selection of modern, widely supported codecs.
    'extras/lazygit',
    'extras/mkcert',
    'extras/posh-git', # PowerShell module that integrates Git and PowerShell by providing Git status summary information
    # command line tools
    'main/cmder-full', # a terminal tool running on Windows
    'main/neovim@0.9.5', # Vim-fork focused on extensibility and usability (0.10.0 is unstable)
    'main/yarn',
    'main/nvm', # A node.js version management utility for Windows
    'main/wget',
    'main/ripgrep',
    'main/fzf',
    'main/make',
    'main/cmake',
    'main/gcc',
    # 'main/ffmpeg',
    # windows famous sysinternals tool
    'sysinternals/sysinternals-suite'
  )

  foreach ($app in $appArray) {
    # Call the function to check and install each app
    InstallPackage -packageName $app
  }

  # Setup git prompt - posh-git on the powershell terminal
  Import-Module "$env:USERPROFILE\scoop\apps\posh-git\current\posh-git.psd1"
  Add-PoshGitToProfile
}

if ($font) {
  # List of programming/coding fonts to be installed
  $fontArray = @(
    'nerd-fonts/Hack-NF-Mono',
    'nerd-fonts/Agave-NF-Mono',
    'nerd-fonts/Meslo-NF-Mono',
    'nerd-fonts/FiraCode-NF-Mono',
    'nerd-fonts/Inconsolata-NF-Mono',
    'nerd-fonts/CascadiaMono-NF-Mono',
    'nerd-fonts/JetBrainsMono-NF-Mono',
    'nerd-fonts/DejaVuSansMono-NF-Mono'
  )

  foreach ($app in $fontArray) {
    # Call the function to check and install each app
    InstallPackage -packageName $app
  }
}

if ($nvim) {
  # setup the Neovim environment
  $nvimPath = "$env:LOCALAPPDATA\nvim"
  if (-Not (Test-Path $nvimPath)) {
    Remove-Item -Path "$env:TEMP\josean-dev-env" -Recurse -Force -ErrorAction Ignore
    Remove-Item -Path "$env:TEMP\envconfig" -Recurse -Force -ErrorAction Ignore
    git clone https://github.com/alexya/josean-dev-env.git "$env:TEMP\josean-dev-env"
    git clone https://github.com/alexya/envconfig.git "$env:TEMP\envconfig"
    Copy-Item -Path "$env:TEMP\josean-dev-env\.config\nvim" -Destination $env:LOCALAPPDATA -Recurse

    # by default, the alacritty.exe is instlled by scoop, if you used another way to install alacritty.exe, please replace it
    $alacrittyPath = "$env:USERPROFILE\scoop\shims\alacritty.exe"
    if (Test-Path $alacrittyPath) {
      if (-Not (Test-Path "$env:APPDATA\alacritty")) {
        Copy-Item -Path "$env:TEMP\josean-dev-env\.config\alacritty" -Destination $env:APPDATA -Recurse
        Copy-Item -Path "$env:APPDATA\alacritty\alacritty_win.toml" -Destination "$env:APPDATA\alacritty\alacritty.toml" -Force
        Remove-Item -Path "$env:APPDATA\alacritty\alacritty_win.toml" -Recurse -Force -ErrorAction Ignore
      }

      # open Alacritty with 'bash' shell on winOS, if you like it please uncomment the following lines
      # $bashPath = "shell = `"$env:USERPROFILE\scoop\shims\bash.exe`""
      # $escapedBashPath = $bashPath -replace '\\', '\\'
      # $alaConfigPath = "$env:APPDATA\alacritty\alacritty.toml"
      # $alaContent = Get-Content -Path $alaConfigPath
      # $alaContent = $alaContent -replace "shell = `"powershell`"", $escapedBashPath
      # Set-Content -Path $alaConfigPath -Value $alaContent

      # Escape backslashes in the path
      $escapedAlacrittyPath = $alacrittyPath -replace '\\', '\\'

      # Prepare the icon for the 'Edit with Neovim' context menu
      $nvimIconPath = "$nvimPath\nvim1.ico"
      $escapedNvimIconPath = $nvimIconPath -replace '\\', '\\'

      # Read the file content
      $regFilePath = "${env:TEMP}\envconfig\alacritty_nvim.reg"
      $content = Get-Content -Path $regFilePath

      # Replace the placeholder with the actual path
      $content = $content -replace "ALACRITTY_PATH", $escapedAlacrittyPath
      $content = $content -replace "NEOVIM_ICON_PATH", $escapedNvimIconPath

      # Write the updated content back to the file
      Set-Content -Path $regFilePath -Value $content

      # Add open with Neovim to the context menu if you want to
      # Run the reg file
      Start-Process -FilePath "regedit.exe" -ArgumentList "/s $regFilePath"
    }
    else {
      Write-Output "alacritty.exe does not exist at the specified path."
    }

    Write-Host "The configurations of the Neovim has been installed."

    # NOTE: The Neovim plunins need to access npmjs website, a mirror may be needed to set in .npmrc
    Write-Host "Please open the Neovim in a Terminal window to complete the plugins setup."
  }
  else {
    Write-Host "The Neovim has been configured before."
  }

  # install node tool nvm
  $nodeVersion = "18.20.4"
  nvm install $nodeVersion
  nvm use $nodeVersion
  $nodeVersion = node --version
  Write-Output "The current node version is: $nodeVersion"
}

if ($python) {
  # install python 3.12.4 (need to change the version according to the environment requirement)
  $python_folder = "C:\python3"
  $python_path = Join-Path -Path $python_folder -ChildPath "python.exe"
  if (-Not (Test-Path $python_path)) {
    Write-Output "Installing python..."
    $python_url = "https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe"
    $python_name = Split-Path -Path $python_url -Leaf
    Get-By-Curl -Url $python_url
    Install-Python -Name "$env:TEMP\$python_name" -python_dir $python_folder
  }
  else {
    Write-Output "Python.exe exists at $python_path"
  }
}

if ($zip7) {
  # install 7zip
  $7zip_dst = "C:\Program Files\7-Zip\7z.exe"
  if (-Not (Test-Path $7zip_dst)) {
    $7zip_url = "https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.4-R1/7z22.01-zstd-x64.exe"
    $7zip_src = Get-By-Curl $7zip_url
    Test-Install -FilePath $7zip_src -TargetFile $7zip_dst -InstallArgs "/S /D=`"C:\Program Files\7-Zip\`""
  }
  else {
    Write-Host "7-zip exists at $7zip_dst"
  }
}

if ($kdiff3) {
  # install KDiff3
  $kdiff3_dst = "C:/Program Files/KDiff3/bin/kdiff3.exe"
  if (-Not (Test-Path $kdiff3_dst)) {
    # 1.10.7 is more stable
    $kdiff3_url = "https://download.kde.org/stable/kdiff3/kdiff3-1.10.7-windows-x86_64.exe"
    $kdiff3_src = Get-By-Curl -Url $kdiff3_url
    Test-Install -FilePath $kdiff3_src -TargetFile $kdiff3_dst
  }
  else {
    Write-Host "kdiff3 exists at $kdiff3_dst"
  }

  # Update the .gitconfig for KDiff3 as diff and merge tool
  Write-Host "Git diff and merge tool are configured"
  git config --global diff.tool kdiff3
  git config --global diff.guitool kdiff3
  git config --global difftool.prompt false
  git config --global difftool.kdiff3.path $kdiff3_dst
  git config --global difftool.kdiff3.trustExitCode false

  git config --global merge.tool kdiff3
  git config --global mergetool.prompt false
  git config --global mergetool.kdiff3.path $kdiff3_dst
  git config --global mergetool.kdiff3.trustExitCode false

  # maybe/shouldbe a individual setting for git config
  git config --global core.pager "less -F -X"
}

if ($sourcegit) {
  # install sourcegit
  $sourcegit_dst = "C:/Program Files/SourceGit/SourceGit.exe"
  $sourcegit_installDir = "C:/Program Files" # because the sourcezip*.zip contains a 'SourceGit' sub folder
  if (-Not (Test-Path $sourcegit_dst)) {
    $sourcegit_url = "https://github.com/sourcegit-scm/sourcegit/releases/download/v8.21/sourcegit_8.21.win-x64.zip"
    $sourcegit_src = Get-By-Curl -Url $sourcegit_url
    Test-Install -FilePath $sourcegit_src -InstallArgs $sourcegit_installDir -TargetFile $sourcegit_dst
  }
  else {
    Write-Host "sourcegit exists at $sourcegit_dst"
  }

  # Create a shortcut on the desktop if it doesn't exist
  $desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'SourceGit.lnk')
  if (-Not (Test-Path $desktopPath)) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($desktopPath)
    $shortcut.TargetPath = $sourcegit_dst
    $shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($sourcegit_dst)
    $shortcut.Save()
    Write-Host "Shortcut for SourceGit created on the desktop"
  }
  else {
    Write-Host "Shortcut for SourceGit already exists on the desktop"
  }
}

if ($chrome) {
  # Install Google Chrome
  $chrome_dst = "C:/Program Files/Google/Chrome/Application/chrome.exe"
  if (-Not (Test-Path $chrome_dst)) {
    $chrome_url = "https://dl.google.com/chrome/install/375.126/chrome_installer.exe"
    $chrome_src = Get-By-Curl -Url $chrome_url
    Test-Install -FilePath $chrome_src -InstallArgs "/silent /install"
  }
  else {
    Write-Host "Google Chrome exists at $chrome_dst"
  }

  # Create a shortcut for Chrome with specific arguments on the desktop if it doesn't exist
  $chromeShortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'Disable security.lnk')
  if (-Not (Test-Path $chromeShortcutPath)) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $chromeShortcut = $WScriptShell.CreateShortcut($chromeShortcutPath)
    $chromeShortcut.TargetPath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    $chromeShortcut.Arguments = "--remote-debugging-port=9222 --disable-web-security --user-data-dir=`"C:/temp/chrome`""
    $chromeShortcut.WorkingDirectory = "C:\Program Files\Google\Chrome\Application"
    $chromeShortcut.Save()
    Write-Host "Shortcut for Chrome with disabled security created on the desktop"
  }
  else {
    Write-Host "Shortcut for Chrome with disabled security already exists on the desktop"
  }
}

if ($notepad) {
  # Check if Traffic Monitor is installed
  $notepadNext_dst = "$env:USERPROFILE\scoop\apps\notepadnext\current"
  if (-Not (Test-Path "$notepadNext_dst\NotepadNext.exe")) {
    # Install Traffic Monitor using Scoop
    InstallPackage -packageName 'extras/notepadnext'
    Write-Host "NotepadNext installed using Scoop"

    # Create the registry keys for Notepad Next
    $notepadnext_path = "$notepadNext_dst\NotepadNext.exe"
    $baseKey = [Microsoft.Win32.Registry]::ClassesRoot

    $notepadNextKey = $baseKey.CreateSubKey("*\shell\NotepadNext")
    $notepadNextKey.SetValue("", "Edit with Notepad Next")
    $notepadNextKey.SetValue("icon", $notepadnext_path)

    $commandKey = $notepadNextKey.CreateSubKey("command")
    $commandKey.SetValue("", "`"$notepadnext_path`" `"%1`"")

    Write-Host "Registry keys for Notepad Next created"
  } else {
    Write-Host "NotepadNext is already installed"
  }
}

if ($monitor) {
  # Check if Traffic Monitor is installed
  $trafficMonitorPath = "$env:USERPROFILE\scoop\apps\trafficmonitor\current"
  if (-Not (Test-Path "$trafficMonitorPath\TrafficMonitor.exe")) {
    # Install Traffic Monitor using Scoop
    InstallPackage -packageName 'extras/trafficmonitor@1.84.1'
    Write-Host "Traffic Monitor installed using Scoop"

    # Replace config.ini file content
    $configFilePath = "$trafficMonitorPath\config.ini"
    $configContent = @"
[general]
check_update_when_start = false
hardware_monitor_item = 3
[task_bar]
tbar_display_item = 111
value_right_align = true
[config]
hide_main_window = 1
show_task_bar_wnd = true
"@
    Set-Content -Path $configFilePath -Value $configContent -Force
    Write-Host "Replaced config.ini file content"
  } else {
    Write-Host "Traffic Monitor is already installed"
  }

  # Download LibreHardwareMonitor-net472.zip
  $libreHardwareMonitorUrl = "https://github.com/LibreHardwareMonitor/LibreHardwareMonitor/releases/download/v0.9.3/LibreHardwareMonitor-net472.zip"
  $fileName = Split-Path $libreHardwareMonitorUrl -Leaf
  $libreHardware_exe = "C:/Program Files/LibreHardwareMonitor/LibreHardwareMonitor.exe"
  $libreHardware_dst = "C:/Program Files/LibreHardwareMonitor"
  $zipFilePath = "$env:TEMP\$fileName"

  # Download the zip file
  if (-Not (Test-Path $zipFilePath)) {
    Get-By-Curl -Url $libreHardwareMonitorUrl
  } else {
    Write-Host "$fileName already exists at $zipFilePath"
  }

  # Extract the zip file
  if (-Not (Test-Path $libreHardware_exe)) {
    Expand-Archive -Path $zipFilePath -DestinationPath $libreHardware_dst -Force
    Write-Host "Extracted $fileName to $libreHardware_dst"
  }

  # Copy LibreHardwareMonitorLib.dll to Traffic Monitor folder
  $sourceDllPath = [System.IO.Path]::Combine($libreHardware_dst, 'LibreHardwareMonitorLib.dll')
  $destinationDllPath = [System.IO.Path]::Combine($trafficMonitorPath, 'LibreHardwareMonitorLib.dll')
  if ((Test-Path $sourceDllPath) -and (Test-Path $destinationDllPath)) {
      $sourceHash = Get-FileHash $sourceDllPath
      $destinationHash = Get-FileHash $destinationDllPath

      if ($sourceHash.Hash -ne $destinationHash.Hash) {
          Copy-Item -Path $sourceDllPath -Destination $destinationDllPath -Force
          Write-Host "Replaced LibreHardwareMonitorLib.dll in Traffic Monitor folder"
      } else {
          Write-Host "Source and destination files are identical. No replacement needed."
      }
  } else {
      Write-Host "Source or destination file does not exist."
  }

  # Create a shortcut on the desktop
  New-Shortcut -ShortcutName "Traffic Monitor" -TargetPath "$trafficMonitorPath\TrafficMonitor.exe" -Location "StartMenu"
  New-Shortcut -ShortcutName "Libre Hardware Monitor" -TargetPath $libreHardware_exe -Location "StartMenu"
}

if ($vsc) {
  # Install Visual Studio Code
  $vscode_dst = "C:/Program Files/Microsoft VS Code/Code.exe"
  if (-Not (Test-Path $vscode_dst)) {
    $vscode_url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
    $vscode_src = Get-By-Curl -Url $vscode_url -FileName "vscode.exe"
    Test-Install -FilePath $vscode_src -InstallArgs "/S /verysilent /mergetasks=!runcode"
  }
  else {
    Write-Host "vscode exists at $vscode_dst"
  }
}

# Function to check if the OS is Windows 11
function Get-Windows11Status {
  $osVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
  return $osVersion -eq "2009"
}

if ($reg) {
  # Check if the OS is Windows 11 and add the registry key
  if (Get-Windows11Status) {
    Write-Host "Running on Windows 11, adding registry key to restore the context menu style to Windows 10"
    # reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
    Start-Process -FilePath "reg.exe" -ArgumentList "add", "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", "/f", "/ve" -Wait -NoNewWindow
  }
  else {
    Write-Host "Not running on Windows 11, skipping registry key addition."
  }
}


if ($vs) {
  # inistall visual studio 2022
  # https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-history
  $VS_name = "Visual Studio Professional 2022"
  if (-not (CheckOnUninstallablePrograms $uninstallablePrograms "$VS_name")) {
    # support Watt
    $VS_Professional_version = 17.10.6
    $VS_download_url = "https://download.visualstudio.microsoft.com/download/pr/28626b4b-f88f-4b55-a0cf-f3eaa2c643fb/c671f39bd1e2ff3a5bc9d7fd05b6b5137dd2761f2e57da62efe6bfbc5bae9865/vs_Professional.exe"
    Write-Host "Installing $VS_name $VS_Professional_version ..."
    Invoke-From-Url -Url $VS_download_url
    Start-Process -FilePath "$env:TEMP\vs_Professional.exe" -ArgumentList "--passive", "--wait", "--norestart", "--nocache", "--installPath C:\MSVS17", "--config $PSScriptRoot\vs.vsconfig" -Wait -NoNewWindow
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 3010) {
      exit $LASTEXITCODE
      Write-Host "Failed to install $VS_name"
      Write-Host "VisualStudio installation logs are found in $logs_dir"
    }

    Write-Host "Succeeded to install $VS_name"
  }
  else {
    Write-Host "$VS_name has been installed before"
  }
}

# register msdia140.dll (not sure if it is still necessary, comment out first)
# Write-Host "register msdia140.dll"
# $regsvrp = Start-Process regsvr32.exe -ArgumentList "/s C:\MSVS17\Common7\Packages\Debugger\msdia140.dll" -PassThru
# $regsvrp.WaitForExit(5000) # Wait (up to) 5 seconds
# if($regsvrp.ExitCode -ne 0)
# {
#     Write-Warning "regsvr32 exited with error $($regsvrp.ExitCode)"
# }


$endTime = Get-Date # Capture the end time
$executionTime = $endTime - $startTime # Calculate the total execution time
Write-Output "" # Print the start time, end time, and total execution time
Write-Output "Start Time: $startTime"
Write-Output "End Time: $endTime"
Write-Output "Total Execution Time: $executionTime"
Write-Host "Installation Complete" -ForegroundColor Green
