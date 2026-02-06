import asyncio

class Interface:
    def __init__(self):
        self.name = "Bot-08 (Interface)"

    async def initialize(self):
        print(f"{self.name}: Initializing...")
        await asyncio.sleep(0.1)
        print(f"{self.name}: Online.")

    async def execute(self):
        pass
