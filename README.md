# Managing My Dotfiles with a Bare Git Repository

This repository (`https://github.com/id-b3/dotfiles`) stores my personal configuration files (dotfiles). I manage them using a technique that leverages a **bare Git repository** and a custom Git alias. This method, popularized by an [Atlassian Developer Blog post](https://www.atlassian.com/git/tutorials/dotfiles) (based on a Hacker News comment by StreakyCobra), offers several advantages:

*   **No extra tooling:** Just Git.
*   **No symlinks:** Files are directly in their expected locations.
*   **Version controlled:** All changes are tracked.
*   **Branching:** Use different branches for different machines or configurations.
*   **Easy replication:** Simple setup on new systems.

## Prerequisites

*   **Git** must be installed on your system.

## How It Works

The core idea is to initialize a bare Git repository in a hidden folder (e.g., `$HOME/.cfg`). A Git alias (e.g., `config`) is then created to interact with this bare repository, specifying `$HOME` as the working tree. This allows you to manage files directly in your home directory as if they were in a standard Git repository, without interfering with other Git repos.

## Setup Instructions

There are two main scenarios:

1.  **Setting up *my* dotfiles on a new system.**
2.  **Migrating *your own existing* dotfiles to this method (or starting fresh with your own).**

---

### 1. Setting Up *My* Dotfiles (`id-b3/dotfiles`) on a New System

Follow these steps to clone and set up my dotfiles on a new machine:

1.  **Clone the bare repository:**
    ```bash
    git clone --bare https://github.com/id-b3/dotfiles $HOME/.cfg
    ```

2.  **Define the `config` alias in your current shell session:**
    ```bash
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    ```

3.  **Add the alias to your shell's configuration file** (e.g., `.bashrc`, `.zshrc`) so it's available in new sessions. Choose one:
    *   For Bash:
        ```bash
        echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
        ```
    *   For Zsh:
        ```bash
        echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
        ```
    *(Remember to `source ~/.bashrc` or `source ~/.zshrc` or open a new terminal for the alias to take effect permanently.)*

4.  **Checkout the content:**
    This command will attempt to place the tracked files into your `$HOME` directory.
    ```bash
    config checkout
    ```

5.  **Handle potential conflicts:**
    If the `config checkout` command fails with an error like "The following untracked working tree files would be overwritten by checkout...", it means some default dotfiles on your new system conflict with those in this repository.
    You can back them up and then retry the checkout:
    ```bash
    mkdir -p .config-backup
    config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    ```
    After backing up, try checking out again:
    ```bash
    config checkout
    ```

6.  **Set the `status.showUntrackedFiles` option to `no` for this repository:**
    This prevents `config status` from showing all other files in your home directory as untracked.
    ```bash
    config config --local status.showUntrackedFiles no
    ```

7.  **You're all set!** You can now manage these dotfiles using the `config` alias (see "Daily Usage" below).

---

### 2. Starting from Scratch or Migrating *Your Own* Dotfiles to This Method

If you want to adopt this technique for *your own* dotfiles (not mine):

1.  **Initialize a new bare Git repository:**
    Choose a directory name for your bare repo (e.g., `.cfg`, `.dotfiles.git`). We'll use `.cfg` here.
    ```bash
    git init --bare $HOME/.cfg
    ```

2.  **Define the `config` alias** (as shown in step 1.2 above) and **add it to your shell configuration file** (as in step 1.3).

3.  **Set `status.showUntrackedFiles` to `no`:**
    ```bash
    config config --local status.showUntrackedFiles no
    ```

4.  **Add files to track:**
    Start adding the dotfiles you want to manage.
    ```bash
    config add .bashrc
    config add .vimrc
    config add .gitconfig
    # etc.
    ```

5.  **Important:** Create a `.gitignore` file *within your dotfiles setup* (e.g., `$HOME/.gitignore`, then `config add .gitignore`) and add the name of your bare repository directory to it. This prevents the bare repo itself from being tracked if you ever accidentally try to add `$HOME`.
    Content of `$HOME/.gitignore` should include:
    ```
    .cfg/
    .config-backup/
    # any other files/dirs in $HOME you always want git (via the 'config' alias) to ignore
    ```
    Then add and commit it:
    ```bash
    config add .gitignore
    config commit -m "Add .gitignore, ignore .cfg and backup dir"
    ```

6.  **Commit your changes:**
    ```bash
    config commit -m "Initial commit of dotfiles"
    ```

7.  **Set up a remote repository** (e.g., on GitHub, GitLab):
    Create a new empty repository on your preferred Git hosting service. Let's say its URL is `YOUR_REPO_URL`.
    ```bash
    config remote add origin YOUR_REPO_URL
    config push -u origin main  # Or 'master' depending on your default branch name
    ```

---

## Daily Usage

Once set up, you interact with your dotfiles repository using the `config` alias instead of `git`:

*   **Check status:**
    ```bash
    config status
    ```
*   **Add files:**
    ```bash
    config add .zshrc
    config add .config/nvim/init.vim
    ```
*   **Commit changes:**
    ```bash
    config commit -m "Update Zsh settings and Neovim config"
    ```
*   **Push changes:**
    ```bash
    config push
    ```
*   **Pull changes (e.g., made on another machine):**
    ```bash
    config pull
    ```
*   **Branching:**
    You can use branches for different machine configurations or experimental setups.
    ```bash
    config branch work-machine
    config checkout work-machine
    # Make changes, commit, push
    config push --set-upstream origin work-machine
    ```

## A Note on the Alias/Function

The alias:
`alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`

A more robust function (handles arguments with spaces better):
```bash
# Add to .bashrc or .zshrc
# function config {
#    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
# }
