# Docker Container for UBports Build Environment

This repository contains a Dockerized environment for porting by UBports to your Android device. The container includes necessary tools and scripts to not bloat your main system with huge amount of packages needed.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Build and Run Docker Container](#build-and-run-docker-container)
3. [Using the Scripts](#using-the-scripts)
    - [Setting Up Kernel and Meta Repositories](#setting-up-kernel-and-meta-repositories)
    - [Customizing Your Build](#customizing-your-build)
4. [Troubleshooting](#troubleshooting)

---

## Prerequisites

- Docker, docker-compose installed on your host system.
- Basic knowledge of terminal commands.
- Access to relevant repositories for your device from [UBports Community Ports](https://gitlab.com/ubports/community-ports).
- and stuff...

---

## Build and Run Docker Container

### Build the Docker Image
```bash
./start-container.sh
```
### Connect to Docker container
```bash
./connect-to-container.sh
```

---

## Using the Scripts

### Setting Up Kernel and Meta Repositories

1. After entering the Docker container, run(for example):
   ```bash
   ./init-standalone-kernel-method.sh
   ```
2. Follow the prompts:
   - Enter the **vendor** for your Android device (e.g., `xiaomi`).
   - Enter the **codename** for your Android device (e.g., `lmi`).
   - Provide the URL for the **kernel repository**.
   - Provide the URL for the **meta repository**.

3. The script will:
   - Create a directory structure under `/home/ubpuser/ubports-builds`.
   - Clone the specified kernel and meta repositories into the appropriate folders.

### Customizing Your Build

- To modify the kernel repository configuration or add patches, navigate to:
  ```bash
  cd /home/ubpuser/ubports-builds/android_device_<VENDOR>_<CODENAME>/halium-<VERSION>
  ```
- Use standard Git commands to interact with the repositories.

---

## Work in progress..

### TODO

1. **Standalone Kernel Method**
    To fully automate the standalone kernel method porting process, the following tasks can be scripted:

    #### 1.1 Automate Device Selection  
    - [ ] **Description:** Create a script to list and select a base device with a similar SoC/Android version automatically.  
        - Use the GitLab API to fetch a list of available devices from `https://gitlab.com/ubports/community-ports`.  
        - Present the list in a user-friendly format.  
        - Allow filtering by SoC, Android version, or manufacturer.  

    #### 1.2 Automate Folder Structure Creation  
    - [x] **Description:** Ensure the required folder structure is created dynamically based on user inputs.  
        - The script already creates necessary folders using `mkdir -p`, ensuring no overwrites if folders exist.  

    #### 1.3 Automate Git Repository Cloning  
    - [x] **Description:** Automate cloning of the kernel and meta repositories for the selected device.  
        - The script prompts the user for kernel and meta repository URLs.  
        - Uses shallow clones (`--depth 1`) to save time and space.  
        - Handles folder structure dynamically.  

    #### 1.4 Automate Configuration File Updates  
    - [ ] **Description:** Modify necessary configuration files dynamically based on the target device.  
        - Replace placeholders in kernel config files with the user's `VENDOR` and `CODENAME`.  
        - Use templates for `manifest.xml` or other required files and populate with device-specific details.  

    #### 1.5 Automate Build Process  
    - [ ] **Description:** Create a unified script to trigger the kernel build process.  
        - Use environment variables to customize build flags (e.g., `HALIUM_VERSION`, `ANDROID_VERSION`).  
        - Detect missing dependencies and provide instructions to install them.  
        - Use logging to track build progress and capture errors.  

    #### 1.6 Automate Deployment and Testing  
    - [ ] **Description:** Create scripts to package the kernel and deploy it to a connected device or emulator.  
        - Package kernel output into a bootable format (e.g., `.img`).  
        - Automate flashing the kernel onto the device using `fastboot` or similar tools.  
        - Run basic validation tests to ensure the kernel boots successfully.  

2. **Enhancements for Docker Workflow**  
    - [x] Add environment variables to the Docker image for easier configuration.  
    - [x] Include pre-installed dependencies and frequently used tools to minimize setup time.  
    - [ ] Provide a script to update the Docker image or rebuild it as required.  

3. **Documentation Improvements**  
    - [ ] Write detailed guides for common issues users might face during the process.  
    - [ ] Include a troubleshooting section with tips on resolving build errors or kernel boot issues.  
    - [ ] Provide examples of successfully ported devices and their configurations.  

### Conclusion
By automating the majority of the standalone kernel porting method, developers can significantly reduce manual effort and focus on fine-tuning their ports. Contributions to these automation tasks are welcome!





---

## Notes
- This container is designed for building UBports for Android devices. Familiarity with porting Android or Halium is recommended.
- Contributions and improvements are welcome!
