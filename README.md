# dotfiles

The dotfiles for my local development environment. This "readme" is intended as a reminder for myself.

# WM configuration + some extras

In addition to the preferred dotfiles, this branch also contains configurations for the i3 window manager as well as some extras (such as mutt).

# Warning

This installation script **deletes certain files** prior to installation. These dotfiles and their installation script come without warranty of any kind. Use this script at your own risk.

# Installation

To install the dotfiles, provide your username.

```
bash install.sh -u username
```

**Note:** If installing on Linux, the default user group is equivalent to the provided username, if on OSX - the user group is `staff`.

# Accounts

Account definitions should be placed in `~/.mutt/accounts`:

- `~/.mutt/accounts/account.example`
- `~/.mutt/accounts/account.another`
- etc

Folder hooks, keybindings and any other account-related configuration should be
placed in `~/.mutt/accounts/init`. An example has been provided
(`~/.dotfiles/mutt/init.example`).

# Local overrides

The following local configurations are supported:

- `.gitconfig_local`
- `.bash_local`
- `.xinitrc_local`
- `.lvimrc` (for each project)
- `.mutt/accounts/init`
- `.mutt/accounts/account.*`
- `.mutt/aliases`

# Custom scripts

All custom scripts may be placed in `$HOME/.scripts`.

# Disclaimer

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
