import serial
import matplotlib.pyplot as plt

# Configure the serial port
serial_port = 'COM18'
baud_rate = 9600

# Initialize the serial port
ser = serial.Serial(serial_port, baud_rate)

# Initialize a list to store data
data_list = []

# Initialize the plot
plt.ion()  # Enable real-time plotting
fig, ax = plt.subplots()
line, = ax.plot([], [])  # Set an initial empty line

# Configure the axes
ax.set_ylim([-20, 20])  # Modify the y-axis limits if necessary
ax.set_xlabel('Time (0.01s)')
ax.set_ylabel('Angle (degree)')
ax.grid(True)  # Add a grid

try:
    while True:
        # Read data from the serial port
        data = ser.readline().decode().strip()

        # Check if the data is not empty
        if data:
            data_value = float(data)  # Convert the value to a float

            # Store the data
            data_list.append(data_value)

            # Update the line on the plot
            line.set_data(range(len(data_list)), data_list)

            # Update the axis limits
            ax.relim()
            ax.autoscale_view()

            # Redraw the plot
            plt.draw()
            plt.pause(0.01)

except KeyboardInterrupt:
    # Interrupt the program when Ctrl+C is pressed
    ser.close()
    print("Ez game!")
