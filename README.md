# FPGA Neural Network
Hardware-based neural network accelerator implemented in SystemVerilog for efficient AI inference.

This project implements a hardware-based neural network on the Altera DE0-CV FPGA in RTL using SystemVerilog. Designed for efficient inference, the system leverages a pretrained FCN neural network with 3 dense layers, including an input layer, hidden layer, output/clasification layer. By pressing a button, the FPGA executes forward propagation to classify input data, making it a compact and responsive system for real-time predictions.

Key Features

	•	Pretrained Model Inference: Uses weights from a pretrained neural network model, stored in on-chip block memory, to perform forward propagation entirely in hardware.
	•	Efficient Design: Implements parallel processing to accelerate computations compared to traditional software implementations.
	•	Input Control via Switch: The system performs inference when a switch is flicked, triggering the hardware logic to process the input data and produce its class prediction.
	•	Modular SystemVerilog Design: Includes separate modules for weight memory management, activation computation, and control logic.
	•	Expandable and Scalable: Supports modifications for different network architectures.

How It Works

	1.	Pretrained Weights:
		•	Weights for the neural network layers are preloaded into on-chip BRAM.
		•	The weights are generated using a software-based training process (python/tensorflow script) and saved in a hardware-compatible format.
	2.	Input Data:
		•	Input features (e.g., image data) are provided to the FPGA.
		•	The system reads these inputs from memory.
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

References

	- Tisan, Alin & Oniga, Stefan & Mic, Daniel & Attila, Buchman. (2009). Digital Implementation of The Sigmoid Function for FPGA Circuits. ACTA TECHNICA NAPOCENSIS Electronics and Telecommunications
 	- Si, Jiong, "Neural Network in Hardware" (2019). UNLV Theses, Dissertations, Professional Papers, and Capstones. 3845. http://dx.doi.org/10.34917/18608784
