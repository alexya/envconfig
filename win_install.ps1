param (
    [switch]$var = $false,
    [switch]$tools = $false,
    [switch]$font = $false,
    [switch]$nvim = $false,
    [switch]$python = $false,
    [switch]$7zip = $false,
    [switch]$kdiff3 = $false,
    [switch]$vsc = $false,
    [switch]$vs = $false,
    [switch]$help = $false,
    [switch]$all = $false
)
# If --all is specified, set all other parameters to true
if($all){
    $var = $true
    $tools = $true
    $font = $true
    $nvim = $true
    $python = $true
    $7zip = $true
    $kdiff3 = $true
    $vsc = $true
    $vs = $true
}

# If --help or no parameters are specified, print the help message
if($help -or ($var -eq $false -and $tools -eq $false -and $font -eq $false -and $nvim -eq $false -and $python -eq $false -and $7zip -eq $false -and $kdiff3 -eq $false -and $vsc -eq $false -and $vs -eq $false -and $all -eq $false)){
    Write-Output "Usage: .\setup.ps1 [-var] [-tools] [-nvim] [-python] [-7zip] [-kdiff3] [-vsc] [-vs] [-all]"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -var        Check and set environment variables"
    Write-Output "  -tools      Install the tools/softwares through Scoop"
    Write-Output "  -font       Install developer-friendly fonts"
    Write-Output "  -nvim       Configure for the neovim and alacritty"
    Write-Output "  -python     Install Python"
    Write-Output "  -7zip       Install 7zip"
    Write-Output "  -kdiff3     Install KDiff3"
    Write-Output "  -vsc        Install Visual Studio Code"
    Write-Output "  -vs         Install Visual Studio"
    Write-Output "  -all        Install all above"
    Write-Output "  -help       Print this help message"
    return
}

# Start define local variables and functions

# define environment variables
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
    } else {
        $name = $packageName
    }

    Write-Host -NoNewline "Checking for "
    Write-Host -NoNewline -ForegroundColor Yellow $name
    Write-Host " installation..."

    if (!(scoop list $name | Select-String -Pattern $name)) {
        Write-Host -NoNewline -ForegroundColor Yellow "$name"
        Write-Host " not found. Installing..."
        scoop install $packageName
    } else {
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
    } else {
        Write-Host -ForegroundColor Green "$bucketName bucket is already added."
    }
}

function Download-From-Url {
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
        } catch {
            # Throw an exception if download failed
            Write-Host "ERROR: Failed to download the file from $Url"
            throw "Failed to download the file from $Url"
        }
    } else {
        Write-Host "File already exists at $destinationPath"
        return $destinationPath
    }
}

function Curl-From-Url {
    param (
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$FileName,

        [Parameter()]
        [string]$DownloadFolder = $env:TEMP
    )

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
        } catch {
            # Throw an exception if download failed
            Write-Host "ERROR: Failed to download the file from $Url"
            throw "Failed to download the file from $Url"
        }
    } else {
        Write-Host "File already exists at $destinationPath"
        return $destinationPath
    }
}

function Check-Install {
    param (
        [Parameter(Mandatory)]
        [string]$FilePath,

        [Parameter()]
        [string]$InstallArgs = '/S',

        [Parameter()]
        [string]$TargetFile
    )

    # If TargetFile is provided, check if it exists
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
			Write-Host "Installing $name ..."
            Start-Process -FilePath $FilePath -Wait -ArgumentList $InstallArgs -NoNewWindow -PassThru
            Write-Host "$name installation succeeded"
        } catch {
            # Throw an exception if installation failed
            Write-Host "ERROR: Failed to install the file from $FilePath"
            throw "Failed to install the file from $FilePath"
        }
    } else {
        # Throw an exception if the source file does not exist
        Write-Host "ERROR: Source file $FilePath not found"
        throw "Source file $FilePath not found"
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

# END define local variables and functions

# Execute the setup/install by the parameters

# environment variables
if ($var) {
  # prompt and add the system/machine environment variables
  $variables = [ordered]@{
      "ACARTIFACTORYUSER" = "The username on the Artifactory server";
      "ACARTIFACTORYPWD" = "The Artifactory API/Identity Token";
      "ACPACKAGEDIR" = "Set it to an SSD drive that has enough space available, > 100GB, e.g. C:\Packages";
      "ACGITUSER" = "Please enter your company Git account username";
      "ACGITPWD" = "Please enter your Git personal access token"
  }

  $envs = @{}
  $maxKeyLength = ($variables.Keys | Measure-Object -Maximum -Property Length).Maximum
  foreach($item in $variables.Keys) {
      $value = [System.Environment]::GetEnvironmentVariable($item, "User")
      if($null -eq $value) {
          $value = Read-Host -Prompt "Please enter a value for $item. Note: $($variables[$item])"
          [System.Environment]::SetEnvironmentVariable($item, $value, "User")
      } else {
          Write-Output "$($item.PadRight($maxKeyLength)) already exists in the User environment variables"
      }
      $envs.Add($item, $value)
  }
}

if ($tools) {
  # Check for Scoop installation
  Write-Host "Checking for Scoop installation..."
  if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
      Write-Host "Scoop not found. Installing Scoop..."
      Set-ExecutionPolicy RemoteSigned -scope CurrentUser
      # iwr -useb get.scoop.sh | iex

      # if you current logon user is a Administrator, please try to install the scoop by the following command
      # and then re-run the current powershell script, refer to: https://github.com/ScoopInstaller/Install
      iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
  } else {
      Write-Host "Scoop is already installed."
  }

  # Check and install 'git', which is a prerequisite for the following installation
  InstallPackage -packageName 'git'

  # Check if buckets 'extras', 'nerd-fonts', and 'sysinternals' exist and install them if not
  $bucketArray = @('extras', 'nerd-fonts', 'sysinternals')
  foreach ($bucket in $bucketArray) {
      InstallBucket -bucketName $bucket
  }

  # Install software(s) from Scoop
  $appArray = @(
      # tools with GUI
      'extras/vcredist2005', # install vcredist 2005, 2008, 2010, 2012, 2013.
      'extras/vcredist2008',
      'extras/vcredist2010',
      'extras/vcredist2012',
      'extras/vcredist2013',
      'extras/vcredist2022', # including vcredist 2015, 2017, 2019, and 2022
      'extras/everything', # A tool to locate files and folders by name instantly.
      'extras/alacritty', # A GPU-accelerated terminal emulator
      'extras/handbrake', # A tool for converting video from nearly any format to a selection of modern, widely supported codecs.
      'extras/lazygit',
      'extras/mkcert',
      # command line tools
      'main/cmder-full', # a terminal tool running on Windows
      'main/neovim@0.9.5', # Vim-fork focused on extensibility and usability
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
}

if ($font) {
  # List of fonts to be installed
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

      # open Alacritty with 'bash' shell on winOS
      $bashPath = "shell = `"$env:USERPROFILE\scoop\shims\bash.exe`""
      $escapedBashPath = $bashPath -replace '\\', '\\'
      $alaConfigPath = "$env:APPDATA\alacritty\alacritty.toml"
      $alaContent = Get-Content -Path $alaConfigPath
      $alaContent = $alaContent -replace "shell = `"powershell`"", $escapedBashPath
      Set-Content -Path $alaConfigPath -Value $alaContent

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
    } else {
        Write-Output "alacritty.exe does not exist at the specified path."
    }
    
    Write-Host "The configurations of the Neovim has been installed."

    # NOTE: The Neovim plunins need to access npmjs website, a mirror may be needed to set in .npmrc
    Write-Host "Please open the Neovim in a Terminal window to complete the plugins setup."
  } else {
    Write-Host "The Neovim has been configured before."
  }

  # install node tool nvm
  $nodeVersion = "18.17.1"
  nvm install $nodeVersion
  nvm use $nodeVersion
  $nodeVersion = node --version
  Write-Output "The current node version is: $nodeVersion"
}

if ($python) {
  # install python 3.9 (need to change the version according to the environment requirement)
  $python_folder = "C:\python39"
  $python_path = Join-Path -Path $python_folder -ChildPath "python.exe"
  if(-Not (Test-Path $python_path)) {
    Write-Output "Installing python..."
    $python_url = "https://www.python.org/ftp/python/3.9.10/python-3.9.10-amd64.exe"
    $python_name = Split-Path -Path $python_url -Leaf
    Invoke-WebRequest -Uri $python_url -OutFile "$env:TEMP\$python_name"
    Install-Python -Name "$env:TEMP\$python_name" -python_dir $python_folder
  } else {
    Write-Output "Python.exe exists at $python_path"
  }
}

if ($7zip) {
  # install 7zip
  $7zip_dst = "C:\Program Files\7-Zip\7z.exe"
  if (-Not (Test-Path $7zip_dst)) {
    $7zip_url = "https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.4-R1/7z22.01-zstd-x64.exe"
    $7zip_src = Download-From-Url -Url $7zip_url
    Check-Install -FilePath $7zip_src -TargetFile $7zip_dst -InstallArgs  "/S /D=`"C:\Program Files\7-Zip\`""
  } else {
    Write-Host "7-zip exists at $7zip_dst"
  }
}
if ($kdiff3) {
  # install KDiff3
  $kdiff3_dst = "C:/Program Files/KDiff3/bin/kdiff3.exe"
  if (-Not (Test-Path $kdiff3_dst)) {
    $kdiff3_url = "https://download.kde.org/stable/kdiff3/kdiff3-1.11.0-windows-x86_64.exe"
      $kdiff3_src = Download-From-Url -Url $kdiff3_url
      Check-Install -FilePath $kdiff3_src -TargetFile $kdiff3_dst
  } else {
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

if ($vsc) {
  # Install Visual Studio Code
  $vscode_dst = "C:/Program Files/Microsoft VS Code/Code.exe"
  if (-Not (Test-Path $vscode_dst)) {
    $vscode_url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
    $vscode_src = Curl-From-Url -Url $vscode_url -FileName "vscode.exe"
    Check-Install -FilePath $vscode_src -InstallArgs "/S /verysilent /mergetasks=!runcode"
  } else {
    Write-Host "vscode exists at $vscode_dst"
  }
}

if ($vs) {
  # inistall visual studio 2022
  $VS_name = "Visual Studio Professional 2022"
  if (-not (CheckOnUninstallablePrograms $uninstallablePrograms "$VS_name")) {
    $VS_Professional_version = 17.8.0
    $VS_download_url = "https://download.visualstudio.microsoft.com/download/pr/eb105084-8c42-4491-a292-51b4ab48d847/10d1c9e432ad28a05f26400c987774630375efe1dcacb6a2eaf1c76ea2516cf7/vs_Professional.exe"
    Write-Host "Installing $VS_name $VS_Professional_version ..."
    Invoke-WebRequest -Uri $VS_download_url -OutFile "$env:TEMP\vs_Professional.exe"
    Start-Process -FilePath "$env:TEMP\vs_Professional.exe" -ArgumentList "--passive", "--wait", "--norestart", "--nocache", "--installPath C:\MSVS17", "--config $PSScriptRoot\vs.config" -Wait -NoNewWindow
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 3010) {
      exit $LASTEXITCODE
      Write-Host "Failed to install $VS_name"
      Write-Host "VisualStudio installation logs are found in $logs_dir"
    }

    Write-Host "Succeeded to install $VS_name"
  } else {
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

Write-Host "Installation Complete" -ForegroundColor Green

