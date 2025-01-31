#!/bin/bash

sleep 2
# Function to check and install FFmpeg if missing
install_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "\e[1;31mFFmpeg is not installed. Installing now...\e[0m"
        
        # Determine OS type and install accordingly
        if [[ "$OSTYPE" == "linux-android"* ]]; then
            rm -rf /data/data/com.termux/files/usr/var/lib/dpkg/lock-frontend
            rm -rf /data/data/com.termux/files/usr/var/lib/dpkg/lock
            kill -9 28287  # 28287 ko replace karein jo process ID (PID) aaye
	    ps aux | grep apt
            apt update && apt install -y ffmpeg
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install ffmpeg
        elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
            echo -e "\e[1;33mPlease install FFmpeg manually from: https://ffmpeg.org/download.html\e[0m"
            exit 1
        else
            echo -e "\e[1;31mUnsupported OS. Install FFmpeg manually.\e[0m"
            exit 1
        fi

        echo -e "\e[1;32mFFmpeg installed successfully!\e[0m"
    else
        echo -e "\e[1;32mFFmpeg is already installed!\e[0m"
    fi
}

# Display user information
echo -e "\e[1;34m===============================================\e[0m"
echo -e "\e[1;32m  𝗙𝗥𝗔𝗠𝗘𝗦 𝗔𝗨𝗗𝗜𝗢 𝗘𝗫𝗧𝗥𝗔𝗖𝗧𝗜𝗢𝗥  \e[0m"
echo -e "\e[1;32m  Created by: Fusion_spirite  \e[0m"
echo -e "\e[1;36m  GitHub: https://github.com/Mastermindtxt  \e[0m"
echo -e "\e[1;36m  Telegram: t.me/Fusion_Spirite  \e[0m"
echo -e "\e[1;34m===============================================\e[0m"
sleep 1

# Check and install requirements
install_ffmpeg
echo "Wait processing...."
sleep 3
echo -e "\e[1;34m===============================================\e[0m"
sleep 4
# Prompt user for input and output paths
read -p "Enter the path to the input video: " input_video
read -p "Enter the directory for output frames: " output_frames
read -p "Enter the output audio file (e.g., audio.mp3): " output_audio
echo -e "\e[1;34m===============================================\e[0m"
sleep 2
# Prompt for extraction settings
read -p "Enter frame width: " width
read -p "Enter frame height: " height
read -p "Enter frame rate (FPS): " fps
read -p "Enter image quality (1-31, lower is better): " quality
echo -e "\e[1;34m===============================================\e[0m"
sleep 1
# Ensure the output directory exists
mkdir -p "$output_frames"

# Display menu options
echo -e "\n\e[1;33mSelect an option:\e[0m"
echo "1) Extract Frames"
echo "2) Extract Audio"
echo "3) Extract Both"
read -p "Enter your choice (1/2/3): " choice
echo -e "\e[1;34m===============================================\e[0m"
sleep 1
case $choice in
    1)
        echo -e "\e[1;34mExtracting frames...\e[0m"
        ffmpeg -i "$input_video" -vf "scale=${width}:${height},fps=${fps}" -q:v "$quality" "$output_frames/frame_%04d.jpg"
        echo -e "\e[1;32mFrames extracted successfully!\e[0m"
        ;;
    2)
        echo -e "\e[1;34mExtracting audio...\e[0m"
        ffmpeg -i "$input_video" -q:a 0 -map a "$output_audio"
        echo -e "\e[1;32mAudio extracted successfully!\e[0m"
        ;;
    3)
        echo -e "\e[1;34mExtracting frames and audio...\e[0m"
        ffmpeg -i "$input_video" -vf "scale=${width}:${height},fps=${fps}" -q:v "$quality" "$output_frames/frame_%04d.jpg"
        ffmpeg -i "$input_video" -q:a 0 -map a "$output_audio"
        echo -e "\e[1;32mFrames and audio extracted successfully!\e[0m"
        ;;
    *)
        echo -e "\e[1;31mInvalid choice. Exiting...\e[0m"
        exit 1
        ;;
esac

