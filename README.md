# 🎯 "Guess It" Game!

Welcome to my number guessing game project. This classic game is built with **x86 Assembly Language** using **NASM** to practice low-level programming concepts.

## About

This project is an Assembly language program that generates a random number between 1-100 and challenges players to guess it within 10 attempts. It demonstrates fundamental Assembly programming concepts including system calls, memory management, and control flow.

## Features

- Random number generation (1-100 range)
- 10 lives system with feedback
- Interactive hints (too high/too low)
- Attempt counter and play again option
- Clean console interface

## Getting Started

**To view the project:**

**For Windows Users:**
If you are on Windows, you must download Ubuntu LTS from the Microsoft Store to use WSL Shell for running the project commands. Additionally, you need to install NASM regardless of your OS to translate the assembly code into machine code.

1. Install WSL and Ubuntu LTS from Microsoft Store

2. Install NASM using your Operating System Shell:
    ```bash
    sudo apt update
    sudo apt install nasm
    ```

3. Clone the repository:

    ```bash
    git clone https://github.com/mattkerbyy/Guess-It-Game.git
    ```

5. Build and run:
    ```bash
    # Open your WSL shell and run
    make run
    ```

**For Linux/macOS Users:**
Install NASM and follow the same build steps above.

> Note: If installing Ubuntu LTS fails, it’s likely because virtualization is disabled in your BIOS. You must reboot, enter your BIOS/UEFI settings, and enable hardware virtualization (often called Intel VT-x, AMD SVM, Virtualization Technology, etc.). Without that, WSL cannot run properly.

## Why I Made This

I built "Guess It" to deepen my understanding of Assembly language programming and explore low-level system interactions. This project helped me learn about memory management, system calls, and the fundamentals of how programs communicate with the operating system.

---

Thank you for checking out my project!
