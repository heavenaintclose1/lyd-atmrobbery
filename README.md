(AI wrote this bit. I couldn't be arsed)
Lyd-ATMRobbery 🏧🥷
A lightweight, optimized ATM robbery script for QB-Core featuring ox_target, ps-ui minigames, and okokBanking integration.

✨ Features
Dynamic ATM Detection: Automatically pulls ATM models directly from your okokBanking config.

LEO Requirement: Set a minimum number of on-duty police required to start a heist.

LEO Blacklist: Prevents players with police/sheriff/highway jobs from robbing ATMs.

Global Cooldown: Each ATM has an individual 30-minute cooldown (based on coordinates).

Easy Minigame: Uses ps-ui Scrambler with customizable difficulty and timers.

Sonoran CAD Ready: Built-in integration for automated police dispatch alerts.

🛠️ Installation
1. Dependencies
Ensure you have the following resources installed:

qb-core

ox_target

ps-ui

okokBanking (Optional/Supported)

2. Manual Installation
Download the resource and place it in your resources/[scripts] folder.

Add the following to your server.cfg (Ensure okokBanking starts first!):

Code snippet
ensure okokBanking
ensure Lyd-ATMRobbery
3. Manifest Setup
If you use a custom name for your banking script, update the @okokBanking/config.lua line in the fxmanifest.lua.

⚙️ Configuration
You can adjust the following in the server.lua:

Payout: Default is $500 - $1250 cash.

Cooldown: Default is 1800 seconds (30 minutes).

Item Loss: Default is 50% chance to lose the Electronic Kit on failure.

📜 License
This project is licensed under the CC-BY-SA 4.0 (Creative Commons Attribution-ShareAlike 4.0 International) License. See the LICENSE file for details.

🤝 Credits
Developer: Lyds (HeavenAintClose)

Framework: QB-Core

UI Assets: Project Sloth (ps-ui)