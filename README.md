# Let's "Tuist" an app

This is the basic project setup for SwiftHeroes 2024 workshop

We'll add more data to this as we proceed with the workshop :)

## Setting up the environment

### Mise

To install mise, you can run this three commands:

```bash
curl https://mise.jdx.dev/install.sh | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

and then restart the terminal.

### Installing Tuist

From this project folder, just run 

```bash
mise install
```

and wait for it <3

### Tuist useful commands

```
# Installing project dependencies
tuist install 

# Generating the project
tuist generate

# Create and open the project graph
tuist graph
```