# Workstation setup guide

>Below you will find a guide to install/configure all required prerequisite to set up development workstation.

>Note the guide assumes you're on either macOS or Linux.

### **Install Homebrew**

`Homebrew` is a very neat package manager for macOs and Linux.

Install by following instructions found at [homebrew](https://brew.sh/). 

Add `homebrew` to path.

```bash
export "/home/linuxbrew/.linuxbrew/bin/:$PATH"
```

Verify `homebrew` was asuccesfuly installed.

```bash
brew --version
```

You should see the below output or something similar.

```bash
dvilajeti@DESKTOP-CVUHB3K:~/repos/todo-app$ brew --version
Homebrew 3.2.5
Homebrew/homebrew-core (git revision 3726a13f0a1; last commit 2021-07-29)
```

### **Install homebrew version of bash**

Install `bash` using `brew`.

```bash
brew install bash
```

### **Install tfenv**

`tfenv` will be used to install/manage different versions of terraform.

```bash
brew install tfenv
```

### **Install and configure pyenv**

Install `pyenv` using `brew`.

```
brew update
brew install pyenv
```

Add pyenv to PATH. To avoid manual entry for each terminal session. We'll configure the environment using `~/.profile`.

Add the below lines at the top of `~/.profile`.

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
```

Then put the below line at the bottom of the same file.

```bash
eval "$(pyenv init --path)"
```

Now install build dependencies for `python` before you proceed to install a version using `pyenv`.

#### **macOS**

```bash
brew install openssl readline sqlite3 xz zlib
```

#### **Ubuntu**

```bash
sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

Now go ahead and install Python 3.9.

```bash
pyenv install 3.9.0
```

To take full advantage of pyenv, we'll install `pyenv-virtualenv`.

```bash
brew install pyenv-virtualenv
```

And add the below line to the bottom of you r ~/.bashrc` file to enable auto activation.

```bash
eval "$(pyenv virtualenv-init -)"
```

Finally restart your shell.

Now you can begin to create your dev virtual environment.

Simply run the below command(s).

```bash
pyenv virtualenv dev-env
pyenv activate dev-env
pip install requiremnts.txt
```

#### **Install the AWS CLI tool**

Go to the [AWS docs](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and folow the instructions to successfully install the aws cli 2.

Once you've installed the cli, you need to configure aws using your account credentials.

```bash
aws configure
```

