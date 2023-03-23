# Housing Data Cleaning

Project focused on cleaning the dataset found in the .xlsx file, which contains information about the housing market in Nashville.

After importing that file in SSMS and creating the 'NashvilleHousing' table on which we will be working, we start by displaying and checking the raw data. 

Now we are ready to continue with the following steps-procedures:

1) 'SaleDate' column: arranging values so that only the date is displayed, without the time (using the CONVERT function),

2) 'PropertyAddress' column: replacing null values with corresponding values from other rows with the same Parcel ID (using the ISNULL function),

3) 'PropertyAddress' column: diving the column into two new ones where the Address and the City are separated (using the SUBSTRING function),

4) 'OwnerAddress' column: diving the column into three new ones where the Address, the City and the State are separated (using the PARSENAME function),

5) 'SoldAsVacant' column: replacing the 'Y' and 'N' values with 'Yes' and 'No' respectively (using a CASE statement),

6) Removing Duplicates: making use of the ROW_NUMBER function, based on specific columns and ordered by the Unique ID, all included in a CTE (Common Table Expression), in order to identify and delete duplicate values,

7) Useless Columns: getting rid of the 'SaleDate', 'PropertyAddress' and 'OwnerAddress' columns, which we already manipulated, as well as the 'TaxDistrict' column, which bares no usefull information and

8) Final Check: simply taking a final look of the updated and cleaned table.

# Results

After all those manipulation and cleaning procedures, the original dataset, which initially consisted of 56477 rows, ends up in a table format, including 56373 rows. In conclusion, we can confidently claim that we cleaned the dataset efficiently enough and brought in a format suitable for future analysis, by only missing 104 rows or the 0.002% of the raw data.
