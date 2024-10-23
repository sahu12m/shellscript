#Python script to list running processes on a system and filter processes based on their memory usage

import psutil

# Function to list processes exceeding memory threshold
def list_processes_by_memory(threshold):
    processes = []
    for proc in psutil.process_iter(['pid', 'name', 'memory_percent']):
        try:
            if proc.info['memory_percent'] > threshold:
                processes.append(proc.info)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass  # Ignore processes we can't access
    return processes

# Test: List processes using more than 1% of memory
for process in list_processes_by_memory(1.0):
    print(f"PID: {process['pid']} | Name: {process['name']} | Memory: {process['memory_percent']:.2f}%")

