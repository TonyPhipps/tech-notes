# OBS Studio Quick-Start Guide: Video Capture Device Setup
A concise, step-by-step guide to quickly capturing video from a console, external camera, or second PC using OBS Studio.


## Initial Setup Checklist
Before opening OBS Studio, ensure your hardware is properly connected:
*   **HDMI Input:** Connect the HDMI cable from your source (console, camera, PC) to the **IN** port of your capture card.
*   **USB Connection:** Plug the capture card into a fast USB port (preferably **USB 3.0/3.1** via a blue port) directly on your motherboard/computer.


## Adding the Capture Device in OBS
1. Open **OBS Studio**.
2. Locate the **Scenes** box (bottom-left) and select or create a Scene.
3. In the **Sources** box, click the **`+` (Add)** icon.
4. Select **Video Capture Device**.
5. Choose **Create New**, name it (e.g., *Console Capture* or *Cam Link*), and click **OK**.


### Hearing the Audio Yourself (Monitoring)
If you cannot hear your capture card audio through your headphones:
1. Locate your capture device in the **Audio Mixer** section at the bottom of OBS.
2. Click the gear icon ($\text{Gear} \rightarrow \text{Advanced Audio Properties}$).
3. Find your device and change **Audio Monitoring** from *Monitor Off* to **Monitor and Output**.


## Adjusting Canvas & Canvas Scaling
If your video feed appears too small or cut off on the screen:

1. Right-click the video feed inside the main preview window.
2. Go to **Transform** > **Fit to screen** (Shortcut: `Ctrl + F`).


## Ready to Record / Stream
*   **To Record:** Click **Start Recording** in the **Controls** dock (bottom-right).
*   **Output Path:** Settings can be adjusted under **Settings** > **Output** > **Recording Path**.
*   **Format:** Recommended recording format is **MKV** or **MOV** (if OBS crashes, MKV saves your progress; convert to MP4 via **File** > **Remux Recordings**).


## Quick Troubleshooting Tip
*   **Black Screen Issue:** 
    1. Ensure HDCP (copy protection) is disabled on your source device (e.g., PS4/PS5 settings under *System* > *Enable HDCP* > *Off*).
    2. Try unplugging and replugging the USB connection of your capture device.
    3. Ensure no other application (Zoom, Discord, Camera app) is using the capture device.