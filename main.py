from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import serial
import time
from dotenv import load_dotenv
import os

# Load environment variables from the .env file
load_dotenv()

# Get values from the .env file (default to 'COM7' and '9600' if not set)
arduino_port = os.getenv("ARDUINO_PORT", "COM7")
baud_rate = int(os.getenv("BAUD_RATE", "9600"))

# Try to connect to the Arduino using the specified port and baud rate
try:
    ser = serial.Serial(arduino_port, baud_rate, timeout=1)
    time.sleep(2)  # Wait for connection to establish
except serial.SerialException as e:
    raise Exception(f"Could not open serial port: {e}")

app = FastAPI()

# CORS settings to allow all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

@app.post("/pump/{action}")
async def control_pump(action: str):
    """
    Control the pump on the Arduino.
    - Send 'on' to turn the pump on.
    - Send 'off' to turn the pump off.
    """
    if action not in ["on", "off"]:
        raise HTTPException(status_code=400, detail="Invalid action. Use 'on' or 'off'.")

    command = "pump_on\n" if action == "on" else "pump_off\n"
    ser.write(command.encode())
    return {"message": f"Pump turned {action}"}

@app.get("/status")
async def get_status():
    """
    Get the current water level status from the Arduino.
    """
    ser.write("status\n".encode())
    time.sleep(1)
    if ser.in_waiting > 0:
        status = ser.readline().decode().strip()
        return {"status": status}
    else:
        raise HTTPException(status_code=500, detail="Failed to get status from Arduino")

@app.on_event("shutdown")
def shutdown_event():
    """Close the serial connection when the server shuts down."""
    ser.close()
    print("Serial connection closed")
