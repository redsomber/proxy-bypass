# Script for Switching Between Squid Proxy and Shadowsocks Based on Server Availability

This PowerShell script allows you to automatically switch between using a Squid proxy and Shadowsocks based on the availability of a specified server. The script checks the server's status, stops or starts the relevant services/processes, and provides the option to switch manually.

## 1. Installing Squid Proxy on Windows

To set up Squid Proxy on Windows, follow these steps:

### 1.1 Installing Squid

1. Download the Squid installer for Windows from a reliable source.
   The official app for windows.

   <https://squid.diladele.com/>

   You need `SQUID FOR WINDOWS` -> `DOWNLOAD MSI`

2. Follow the installation wizard to install Squid on your machine.

### 1.2 Configuring Squid to Listen on Port 1080

1. Locate the Squid configuration file, typically found in `C:\Squid\etc\squid.conf`.
2. Open `squid.conf` in a text editor (with administrator privileges).
3. Find the line that starts with `http_port` and change the port number to `1080`, so it reads:

   ```plaintext
   http_port 1080
   ```

4. Save the file and restart the Squid service to apply the changes.

## 2. Downloading and Moving the Script

1. Download the provided PowerShell script.
2. Move the script to your desired directory, for example, `D:\sw.ps1`.

## 3. Configuring the Script

Before running the script, make sure to configure it according to your environment:

1. Open the script file in a text editor.
2. Modify the following variables with your own values:

   ```powershell
   $server = "123.123.123.123"
   $shadowsocksPath = "C:\Program Files\Shadowsocks\Shadowsocks.exe"
   ```

   Replace `123.123.123.123` with your server's IP address and adjust the path to the Shadowsocks executable if necessary.

## 4. Creating a Shortcut for Easy Execution

To run the script easily, create a shortcut:

1. Right-click on your desktop or in a folder, select `New` > `Shortcut`.
2. In the location field, enter the following command, adjusting the path to your script:

   ```plaintext
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "D:\sw.ps1"
   ```

3. Name the shortcut, for example, `SwitchProxy`.
4. Click `Finish`.

Now, you can simply double-click the shortcut to execute the script.

## 5. Adding Shadowsocks and Squid to Firewall and Antivirus Exceptions

To ensure uninterrupted operation, add both Shadowsocks and Squid to your firewall and antivirus exceptions:

### 5.1 Adding to Windows Firewall

1. Open the Control Panel and go to `System and Security` > `Windows Defender Firewall`.
2. Click on `Allow an app or feature through Windows Defender Firewall`.
3. Click `Change settings`, then `Allow another app`.
4. Browse and add `Shadowsocks.exe` and `Squid.exe` (located in their respective installation directories).
5. Ensure both are allowed for both `Private` and `Public` networks.

### 5.2 Adding to Antivirus Exceptions

1. Open your antivirus software.
2. Navigate to the `Exclusions` or `Exceptions` section.
3. Add the paths to `Shadowsocks.exe` and `Squid.exe` as exceptions.

## 6. Running the Script

To run the script:

1. Double-click the shortcut you created in Step 4.
2. Follow the on-screen prompts to switch between the Squid proxy and Shadowsocks based on your server's status.

## 7. Additional Considerations

- **Logging:** The script logs its operations to a file located at `D:\logfile.txt`. You can change this path if necessary.
- **Polling Interval:** Adjust the `$interval` variable in the script to change how often the server status is checked (in seconds).
- **Customizing Poll Count:** The `$pollCount` variable defines how many consecutive successful pings are required to consider the server online. Adjust this for reliability.

Feel free to modify the script further to meet your specific requirements.
