## 🐝 The Swarm Protocol (10-Bot Array)
To ensure modularity and prevent logic-drift, the project is divided into 10 specialized units:

1-3 (DATA): [Dissector, Librarian, Strategist] -> Task: Dissect JSON and build the Brain.
4-7 (TACTICAL): [Navigator, Aviator, Harvester, Combatant] -> Task: Build the Body and Flight logic.
8-10 (SYSTEMS): [Interface, Monitor, Integrator] -> Task: Build the UI and Git-Sync.

**Instruction for Jules:** Assign one internal thread to each Bot. Each Bot must code its specific module in a separate file within the `/modules/` directory.
