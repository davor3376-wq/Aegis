import asyncio
import sys
import os

# Add repo root to path so we can import modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from modules.bot_01_dissector import Dissector
from modules.bot_02_librarian import Librarian
from modules.bot_03_strategist import Strategist
from modules.bot_04_navigator import Navigator
from modules.bot_05_aviator import Aviator
from modules.bot_06_harvester import Harvester
from modules.bot_07_combatant import Combatant
from modules.bot_08_interface import Interface
from modules.bot_09_monitor import Monitor
from modules.bot_10_integrator import Integrator

async def main():
    print("Delta Executor: Initializing Swarm Protocol...")

    # Bot 01 is handled separately as its task is already done/verified
    print("Bot-01 (Dissector): Online (Data Dissected).")

    bots = [
        Librarian(),
        Strategist(),
        Navigator(),
        Aviator(),
        Harvester(),
        Combatant(),
        Interface(),
        Monitor(),
        Integrator()
    ]

    # Initialize Bots 02-10 concurrently
    tasks = [bot.initialize() for bot in bots]

    await asyncio.gather(*tasks)

    print("Swarm Online")

if __name__ == "__main__":
    asyncio.run(main())
