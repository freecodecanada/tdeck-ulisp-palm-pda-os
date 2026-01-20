Palm PDA OS (uLisp) — LilyGO T-Deck

A Palm-inspired PDA-style operating system that runs inside uLisp on the LilyGO T-Deck. This project focuses on stability, simplicity, and a retro interface while still allowing complex apps to be built on top. Built using uLisp — full credit to https://ulisp.com
 for the language, firmware, and documentation.

This is not a traditional operating system. It runs as a persistent uLisp workspace and uses uLisp’s image system to save code and state across reboots. Think of it as a small, self-contained PDA environment built in Lisp.

Requirements: LilyGO T-Deck (ESP32), uLisp firmware installed, and a serial terminal (CoolTerm recommended).

Installing uLisp: Go to https://ulisp.com
 and follow the ESP32 installation instructions for the LilyGO T-Deck. Flash uLisp using the Arduino IDE or PlatformIO. Open a serial terminal and confirm you see the > prompt.

Installing the PDA OS: Open your serial terminal. At the > prompt, paste the OS source one small block at a time, always waiting for the > prompt before pasting the next block. After all blocks are loaded, run (save-image) to store the OS in uLisp’s persistent workspace.

Running the OS: After a reset or power cycle, run (load-image) followed by (boot). Save changes at any time using (save-image).

Paste rules: Paste one block at a time. Keep blocks small to avoid serial crashes. If a paste fails, resend that same block. Avoid re-registering menus unless you reset them first.

Main features include a custom retro boot screen, battery monitoring via ADC, a toggleable status bar, simple Apps and System menus, a lightweight app runner shell, a persistent Notes app, and system tools for saving, loading, and rebooting.

Navigation: From the main menu, press 1 for Apps, 2 for System, or 0 to quit the menu loop. Inside menus, enter a number to run an item or 0 to go back. At any time, (home) will return to the main menu.

Apps: The included Notes app allows you to view notes from the Apps menu. Notes can be added manually using (notes-add "text") and removed using (notes-pop).

System menu tools include System Info, Garbage Collection, Uptime (boot count), Save Image, Load Image, Save + Reboot, Reboot OS, Clear Screen, Battery Details, Apps List, and Toggle Status Bar.

Command reference: Core commands include (boot), (cls), and (pause). Persistence commands include (save-image) and (load-image). Navigation uses (home). Battery and UI interaction includes (status-bar) and the Toggle Status Bar system item. Notes commands include (notes-add "text"), (notes-show), and (notes-pop).

The source code is organized into intentionally small logical blocks covering core utilities, battery handling, boot graphics, notes, app registries, UI shell, menus, system tools, and startup logic. Blocks are kept small to ensure reliable serial pasting.

This OS is designed so the menu remains simple while apps can be complex internally. Suitable next apps include a task manager, document viewer, settings app, calculator, or other utilities, all without changing the core OS.
