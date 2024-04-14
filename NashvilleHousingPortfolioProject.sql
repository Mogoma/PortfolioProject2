--Cleaning data with sql queries

SELECT *
 FROM PortfolioProject.dbo.NashvilleHousing


 --Stanardie the SaleDate
 SELECT SaleDate, CONVERT(Date, SaleDate)
 FROM PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ALTER COLUMN SaleDate Date

 --Breaking address into individual columns (Address, City, State)
 SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
 ,  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS Address
 
 FROM PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD PropertySplitAddress nvarchar(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD PropertySplitCity nvarchar(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

 

 --Breaking the owner address
 SELECT
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
 FROM PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitAddress nvarchar(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitCity nvarchar(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnerSplitState nvarchar(255)

 UPDATE PortfolioProject.dbo.NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

 --Change letters Y and N to Yes and No in the 'SoldAsVacant' field
 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM PortfolioProject.dbo.NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY 2

 SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

--Removing duplicates
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				  UniqueID
				  ) row_num
FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
--DELETE 
--FROM RowNumCTE
--WHERE row_num > 1

SELECT * 
FROM RowNumCTE


--Delete unused columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

SELECT * FROM PortfolioProject.dbo.NashvilleHousing


