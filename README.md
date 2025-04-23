# Coin Classification Using Image Processing and Unsupervised Learning in MATLAB

**Overview**
This MATLAB project demonstrates an image processing pipeline to detect, segment, and classify coins (dimes, nickels, quarters) from a composite grayscale image using Otsu thresholding, morphological operations, template matching filters, and unsupervised learning (k-means clustering).

**The main goals of this project are:**

- Segment and localize coins from a test image combining two built-in MATLAB images.
- Extract relevant features from each coin using custom-designed matching filters.
- Classify coins into three categories using k-means clustering based on filter correlation features.
- Visualize and label each detected coin type and calculate the total coin value.

**Key Steps**
**1. Image Preparation:**
Combined two grayscale images (coins.png and inverted eight.tif) into a single test image with zero-padding to allow border processing.

**2. Segmentation:**
- Applied Otsu’s method for thresholding to create a binary mask.
- Used morphological dilation and erosion to refine coin shapes.
- Extracted connected components to find individual coins and calculate their centroids and sizes.

**3. Feature Extraction:**
- Designed circular matching filters for dimes, nickels, and quarters using a custom MakeCircleMatchingFilter function.
- Measured the correlation of each coin’s local region with each matching filter, resulting in a 3-dimensional feature vector for every coin.

**4. Clustering and Classification:**
- Performed k-means clustering on the feature vectors to classify coins into 3 groups.
- Re-mapped the cluster labels based on the average size of coins in each group (smallest = dime, middle = nickel, largest = quarter).

**5. Visualization:**
- Plotted colored circles around each coin based on its classified type.
- Calculated and displayed the total value of the coins in the image.

**Tools & Techniques Used**
- MATLAB Image Processing Toolbox
- Otsu Thresholding
- Morphological Operations (Dilation & Erosion)
- Connected Component Analysis
- Correlation-Based Template Matching
- Unsupervised Learning (k-means)

**Example Output**
- Segmented binary masks after thresholding and morphological filtering.
- Matching filters for dimes, nickels, and quarters.
- Clustered coins labeled with their type and total value shown.

**Repository Contents**
main.m: Main script executing the full pipeline.

MakeCircleMatchingFilter.m: Function to generate circular filters for matching.

OtsuThreshold.m: Function implementing Otsu’s method (if not built-in).

AddCoinToPlotAndCount.m: Helper for plotting results and calculating value.

Output images of the processing steps (optional for documentation).

**How to Run:**
- Clone this repository.
- Open MATLAB and navigate to the project directory.
- Run main.m.
- Ensure coins.png and eight.tif are available in your MATLAB path (they are built-in images).


