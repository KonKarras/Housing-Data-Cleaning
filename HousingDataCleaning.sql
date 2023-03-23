-- HOUSING DATA CLEANING 

-- Dataset's Check
-- Simply starting with displaying the dataset we will be working with.

Select * 
From NashvilleHousing

-- 'Sale Date'
-- Changing the date format so that the time is not displayed.

Select SaleDate, CONVERT(date, SaleDate)
From NashvilleHousing

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDate, SaleDateConverted
From NashvilleHousing

-- 'Property Adddress'
-- Populating data where Property Address in null.

Select *
From NashvilleHousing
Where PropertyAddress is null

Select *
From NashvilleHousing
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
	   ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Spliting Property Address into Address and City.

Select 
	   SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- 'Owner Address'
-- Spliting Owner Address into Address, City and State.

Select OwnerAddress,
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- 'Sold As Vacant'
-- Replacing 'Y' and 'N' values with 'Yes' and 'No' respectively.

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	   CASE 
	        When SoldAsVacant = 'Y' Then 'Yes'
	        When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
       END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE 
	                    When SoldAsVacant = 'Y' Then 'Yes'
	                    When SoldAsVacant = 'N' Then 'No'
			            Else SoldAsVacant
                   END

-- Removing Dublicates

With RowNumCTE as
(
Select *, ROW_NUMBER() over
       (     
	   Partition by ParcelID,
	                PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
	   Order by UniqueID
	   ) row_num
From NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1

-- Useless Columns

Alter Table NashvilleHousing
Drop Column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

-- Final Check

Select *
From NashvilleHousing