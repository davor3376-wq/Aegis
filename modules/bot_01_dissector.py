import asyncio
import json
import os
import re

class Dissector:
    def __init__(self, input_file='Aegis_Ultimate_Manifest.json', output_dir='data'):
        self.input_file = input_file
        self.output_dir = output_dir

    async def dissect(self):
        print(f"Bot-01 (Dissector): Reading {self.input_file}...")

        # Read the large JSON file in a thread to avoid blocking the event loop
        try:
            with open(self.input_file, 'r', encoding='utf-8') as f:
                data = await asyncio.to_thread(json.load, f)
        except FileNotFoundError:
            print(f"Error: {self.input_file} not found.")
            return

        print(f"Bot-01 (Dissector): Found {len(data)} items. Dissecting...")

        tasks = []
        for key, value in data.items():
            tasks.append(self.save_chunk(key, value))

        await asyncio.gather(*tasks)
        print("Bot-01 (Dissector): Dissection complete.")

    async def save_chunk(self, key, value):
        # Sanitize filename
        safe_key = re.sub(r'[^a-zA-Z0-9]', '_', key).lower()
        # Remove repeated underscores
        safe_key = re.sub(r'_+', '_', safe_key).strip('_')
        filename = f"{safe_key}.json"
        filepath = os.path.join(self.output_dir, filename)

        # Write to file in a thread
        await asyncio.to_thread(self._write_json, filepath, value)
        # print(f"Bot-01 (Dissector): Saved {filename}")

    def _write_json(self, filepath, data):
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4)

if __name__ == "__main__":
    dissector = Dissector()
    asyncio.run(dissector.dissect())
