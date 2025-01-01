# DriveMate - Smart Driving Assistant

Real-time driving assistance app designed to enhance road safety. Leveraging on-device Machine Learning using the YOLO11 Object Detection model, this app detects and tracks traffic objects, vehicles, and pedestrians, providing alerts to the driver. The goal is to assist drivers by improving awareness of their surroundings and reducing the risk of accidents.

## Key Features
- **Real-Time Object Detection**: Identifies vehicles, pedestrians, and traffic objects in real-time.
- **Focused Detection**: Configured to detect specific object classes relevant to driving safety, such as cars, buses, trucks, and pedestrians.
- **Lightweight Design**: Optimized for performance on iOS devices using the CoreML framework.

## Technologies Used
- **YOLO11**: Advanced object detection model optimized for traffic scenarios.
- **CoreML**: Efficient deployment of the YOLOv11 model on iOS devices.
- **SwiftUI**: Modern UI framework for a smooth and responsive user experience.

## How It Works
1. **Detection**: The YOLOv11 model processes the video feed to identify objects of interest.
2. **Tracking**: The app tracks detected objects and determines if they pose a hazard.
3. **Alerting**: Alerts notify the driver of obstacles ahead.
