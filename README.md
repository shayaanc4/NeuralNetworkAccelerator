# NeuralNetworkAccelerator
FPGA-based neural network accelerator implemented in SystemVerilog for efficient hardware inference.

This project implements a hardware-based neural network accelerator on the Altera DE0-CV FPGA in RTL using SystemVerilog. Designed for efficient inference, the system leverages a pretrained neural network with 3 dense layers: input layer, hidden layer, output/clasification layer. By pressing a button, the FPGA executes forward propagation to classify input data, making it a compact and responsive system for real-time predictions.

Key Features

	•	Pretrained Model Inference: Uses weights from a pretrained neural network model, stored in on-chip block memory, to perform forward propagation entirely in hardware.
	•	Efficient Design: Implements parallel processing and pipelining to accelerate computations compared to traditional software implementations.
	•	Input Control via Button Press: The system performs inference when a button is pressed, triggering the hardware logic to process the input data and produce its class prediction.
	•	Modular SystemVerilog Design: Includes separate modules for weight memory management, activation computation, and control logic.
	•	Expandable and Scalable: Supports modifications for different network architectures.

How It Works

	1.	Pretrained Weights:
		•	Weights for the neural network layers are preloaded into on-chip BRAM.
		•	The weights are generated using a software-based training process (python/tensorflow script) and saved in a hardware-compatible format.
	2.	Input Data:
		•	Input features (e.g., image data) are provided to the FPGA.
		•	The system reads these inputs from memory or external peripherals.
	3.	Button-Triggered Inference:
		•	Pressing a designated button triggers the control logic to start the forward propagation process.
		•	The FPGA computes the activations layer by layer, using the stored weights and biases.
	4.	Output:
		•	The output classification or prediction is displayed (e.g., via HEX displays or other peripherals) or sent to a host system for further processing, alongside the input data's given label.

Project Goals

	•	Explore hardware acceleration for neural networks using RTL design.
	•	Demonstrate the practical implementation of inference on an FPGA.
	•	Showcase how to manage large-scale weights and activations in memory-constrained environments.

Applications

This project is suitable for scenarios requiring fast, low-power inference, such as:

	•	Edge computing
	•	Embedded AI systems
	•	Real-time object classification
