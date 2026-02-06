import asyncio

class Aviator:
    def __init__(self):
        self.name = "Bot-05 (Aviator)"

    async def initialize(self):
        print(f"{self.name}: Initializing...")
        await asyncio.sleep(0.1)
        print(f"{self.name}: Online.")

    async def execute(self):
        pass
