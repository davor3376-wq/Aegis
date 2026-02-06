import asyncio

class Harvester:
    def __init__(self):
        self.name = "Bot-06 (Harvester)"

    async def initialize(self):
        print(f"{self.name}: Initializing...")
        await asyncio.sleep(0.1)
        print(f"{self.name}: Online.")

    async def execute(self):
        pass
