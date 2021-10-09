select * From [portfolio project]..housing_NV



select cast(SaleDate as date) from housing_NV

alter table housing_NV
add sale_Date_Date date

update housing_NV
set sale_Date_Date = convert(date, SaleDate)



--propgate property addess nulls--


select  a.PropertyAddress,a.ParcelID,b.PropertyAddress,b.ParcelID,
isnull(a.PropertyAddress, b.PropertyAddress)
From [portfolio project]..housing_NV a
join 
[portfolio project]..housing_NV b
on 
a.ParcelID = b.ParcelID
and
a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

--update to table--

update a
set PropertyAddress =  isnull(a.PropertyAddress, b.PropertyAddress)
From [portfolio project]..housing_NV a
join 
[portfolio project]..housing_NV b
on 
a.ParcelID = b.ParcelID
and
a.[UniqueID ] != b.[UniqueID ]



select * from [portfolio project]..housing_NV 
where PropertyAddress is null



--spliting strings of propertyaddress--  


select  SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)  as address ,

SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as city

from  housing_NV



alter table Housing_NV
add property_address varchar(222)

update housing_NV
set property_address =  SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1) 


--update the address in housing columns--

alter table Housing_NV
add property_city varchar(222)

update housing_NV
set property_city =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))



--check
select * from housing_NV

 

--spliting owners address using parse name-- 


select OwnerAddress,

PARSENAME(replace(OwnerAddress, ',', '.'),3),

PARSENAME(replace(OwnerAddress, ',', '.'),2),

PARSENAME(replace(OwnerAddress, ',', '.'),1)

from housing_NV



--updating address in table -- 


alter table Housing_NV
add Street_name Varchar(200)


update housing_NV
set Street_name  =   PARSENAME(replace(OwnerAddress, ',', '.'),3)



alter table Housing_NV
add City_name Varchar(200)


update housing_NV
set City_name  =   PARSENAME(replace(OwnerAddress, ',', '.'),2)


alter table Housing_NV
add State_name Varchar(200)


update housing_NV
set State_name  =   PARSENAME(replace(OwnerAddress, ',', '.'),1)



select * from housing_NV



---change y as yes and n as No in soldasvacant--


select 
case 
when SoldAsVacant = 'Y' then 'Yes'
when  SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
From housing_NV

--updating to table--

update housing_NV
set SoldAsVacant =   
case 
when SoldAsVacant = 'Y' then 'Yes'
when  SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end





--remove duplicates-- using rownmber /partition by and cte

--1) to create unique rownumber 

select * , 

ROW_NUMBER() OVER(Partition by PropertyAddress, SalePrice, ParcelID, SaleDate,LegalReference order by UniqueID) as new

from housing_NV


--2) convert into cte and select duplicate rows aka  non unique values aka no 2


with rownocte as 
(
select * , 

ROW_NUMBER() OVER(Partition by PropertyAddress, SalePrice, ParcelID, SaleDate,LegalReference order by UniqueID) as new

from housing_NV)
select * from rownocte
where new >1


--3) delete the duplicates which are greater than 1



with rownocte as 
(
select * , 

ROW_NUMBER() OVER(Partition by PropertyAddress, SalePrice, ParcelID, SaleDate,LegalReference order by UniqueID) as new

from housing_NV)
delete from rownocte
where new >1



--4) to recheck 

with rownocte as 
(
select * , 

ROW_NUMBER() OVER(Partition by PropertyAddress, SalePrice, ParcelID, SaleDate,LegalReference order by UniqueID) as new

from housing_NV)
select * from rownocte
where new >1




--deleted un used  columns --

select * from housing_NV

alter table housing_Nv
DROP column owneraddress , Taxdistrict , propertyaddress











 






 






















