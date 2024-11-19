The application starts by displaying the home screen when the user opens it.
The user then initiates the barcode scanning process, resulting in a scan request. Once the barcode has been scanned, the application checks whether the product already exists in our database. If it does, it requests the recommended products, retrieves them and displays the product data with the recommendations.
If the product does not exist in our database, the application sends a request for product data to the OpenFood API. If the product exists in the API, it requests a classification of the product from our classification model deployed in Micorsoft Azure, receives this classification and saves the new product data in our database. After registration, the application displays the product data with the classification and recommendations.
If the product does not exist in the OpenFood API either, the application prompts the user to enter the nutritional data manually. Once the data has been entered, it requests a classification for the product from our classification model, receives the classification and saves the manually entered data in our database. Once the registration has been confirmed by us, the application can display product data with classification and recommendations.

-------------------------------------------------------------------------:App pipeline:---------------------------------------------------------------------
![1](https://github.com/user-attachments/assets/91d73657-9b31-48a2-864d-10414a3f9926)

----------------------------------------------------------------------:Sequences diagram:-----------------------------------------------------------------
![2](https://github.com/user-attachments/assets/06e01213-7567-4f10-a72a-d8aaa9d4ea7e)
