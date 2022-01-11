# Invoke-Terminal

Invoke-Terminal is a Powershell Module for launching a set of JSON configured Windows Terminal commands.

Invoke-Terminal is inspired by [Tmuxinator](https://github.com/tmuxinator/tmuxinator)

![sample launch](/docs/sample.png)

## Installation

Git Clone, then import module.
You can add the module to your Powershell session scripts.

```bash
git clone https://github.com/kianryan/Invoke-Module/
cd Invoke-Module
Import-Module Invoke-Terminal.psm1
```

## Usage

Configuration files are json formatted parameters to be passed to Windows Terminal.

Sample config can be found in sample.jsonc

If environment variable "invoketerminal" is set to a folder, Invoke-Terminal can launch from any location:

```powershell
Invoke-Terminal sample
```

If environment variable is not set, or .\ is prefixed to filename, file will be loaded from passed filename:

```powershell
Invoke-Terminal sample.jsonc
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
