use DataCleaning
select * from [NashVilleHousing]

--Standardize Date Format 

select SaleDate
from [NashVilleHousing]


alter table NashVilleHousing 
add SaleDateConverted date;
update [NashVilleHousing]
set SaleDateConverted = CONVERT(date,SaleDate)


select SaleDateConverted
from [NashVilleHousing]

--Populate Property Adress Data

use DataCleaning
select * from NashVilleHousing


select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
		ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashVilleHousing a
	join NashVilleHousing b
		on a.ParcelID = b.ParcelID 
		and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress from NashVilleHousing


select 
	substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
	substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress )) as State
from NashVilleHousing



--ADDRESS_SPLIT


alter table NashVilleHousing 
add PropertySplitAddress Nvarchar(255);

update [NashVilleHousing]
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)


--CITY_SPLIT

alter table NashVilleHousing 
add PropertySplitCity Nvarchar(255);

update [NashVilleHousing]
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress ))



--OwnerAddress Split


SELECT OwnerAddress FROM NashVilleHousing

select
		PARSENAME(replace(owneraddress,',','.'),3), --as OwnerSplitAddress,
		PARSENAME(replace(owneraddress,',','.'),2), --as OwnerSplitCity,
		PARSENAME(replace(owneraddress,',','.'),1) --as OwnerSplitState
FROM NashVilleHousing


alter table NashVilleHousing
add OwnerSplitAddress nVARCHAR(255);
update NashVilleHousing
set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)


alter table NashVilleHousing
add OwnerSplitCity nVARCHAR(255);
update NashVilleHousing
set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2)


alter table NashVilleHousing
add OwnerSplitState nVARCHAR(255);
update NashVilleHousing
set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),1)

SELECT * FROM NashVilleHousing

-- Change Y and N to Yes and No in SoldAsVacant field

select distinct SoldAsVacant
from NashVilleHousing

Select SoldAsVacant,
	(case 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldasVacant
	end) 
from NashVilleHousing


update NashVilleHousing
set SoldAsVacant = (case 
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldasVacant
	end)


-- REMOVE DUPLICATES

with RowNumC as (
SELECT *,
	ROW_NUMBER() over (
	partition by ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice,
			LegalReference
			Order by UniqueID 
			) Rownum
FROM NashVilleHousing )

Select * from RowNumC where rownum > 1 


--Delete Unusual Colunms

Select * from NashVilleHousing
	
alter table  NashVilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate






 

	
