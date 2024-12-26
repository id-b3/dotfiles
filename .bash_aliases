# Reboot directly to Windows
# Inspired by http://askubuntu.com/questions/18170/how-to-reboot-into-windows-from-ubuntu
reboot_to_windows ()
{
    windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias vim=nvim
alias vi=nvim
alias myissues='jira issue list -s"Open" -s"In Progress" -s"Reviewing" -a$(jira me)'

#Algo-dev aliases
runVerapyTestsSlurm() {
    local jobScript="/tmp/run_verapy_tests_$$.sh" 
    cat > "$jobScript" << 'EOF'
#!/bin/bash

#SBATCH --job-name=VerapyTests        # Job name
#SBATCH --output=/nas/temp/Ivan/slurm_jobs/slurm-%j.out  # Output file
#SBATCH --error=/nas/temp/Ivan/slurm_jobs/slurm-%j.err   # Error file
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --mem=30G                    # Total memory limit
#SBATCH --gres=gpu:1                 # Request GPU resource
#SBATCH --nice=100                   # Set niceness of job

# Adjust these commands according to your environment if needed
module load python/3.8  # Example: loading Python 3.8; adjust according to your setup

# If you have a Python virtual environment, activate it
# source /path/to/your/venv/bin/activate  # Uncomment and edit if necessary

# The command you want to run
coverage run --source=verapy -m unittest discover verapy -v && coverage run -a -m pytest verapy -k "test_integration_"
EOF

    # Make the job script executable and submit it
    chmod +x "$jobScript"
    sbatch "$jobScript"
}
alias submitVerapyTests='runVerapyTestsSlurm'

#Algo-dev aliases
runPrototypeTestsSlurm() {
    local jobScript="/tmp/run_prototype_tests_$$.sh" 
    cat > "$jobScript" << 'EOF'
#!/bin/bash

#SBATCH --job-name=PrototypeTests        # Job name
#SBATCH --output=/nas/temp/Ivan/slurm_jobs/slurm-%j.out  # Output file
#SBATCH --error=/nas/temp/Ivan/slurm_jobs/slurm-%j.err   # Error file
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --mem=30G                    # Total memory limit
#SBATCH --gres=gpu:1                 # Request GPU resource
#SBATCH --nice=100                   # Set niceness of job

# If you have a Python virtual environment, activate it
# source /path/to/your/venv/bin/activate  # Uncomment and edit if necessary

# The command you want to run
lint_result=0 ; pylint prototypes --disable=R,C,I,W --fail-on=E,F,W0401,W0611,C0410,C0411,C0412,C0413,C0414,C0415 --rcfile=pyproject.toml --reports=y --output-format=json:pylint_report_linux.json,colorized || lint_result=$?
pylint prototypes --disable=R,C,I,E,F --rcfile=pyproject.toml --reports=y
python -m black --check prototypes
coverage run --source=prototypes -m unittest discover prototypes -v
coverage run -a -m pytest prototypes -k "test_integration_"
EOF

    # Make the job script executable and submit it
    chmod +x "$jobScript"
    sbatch "$jobScript"
}
alias submitPrototypeTests='runPrototypeTestsSlurm'
alias si="~/bin/info2.sh"
alias update_repo="git pull && pip install -r requirements.txt && pip install -e ."
