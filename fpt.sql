
create table nhacungcap(
	maNhaCC int primary key,
    tenNhaCC varchar(255),
    diaChi varchar(255),
    soDt varchar(10),
    maSoThue varchar(10)
);

create table loaiDichVu(
	maLoaiDV int primary key,
    tenDV varchar(255)
);

create table mucPhi(
	maMucPhi int primary key,
    donGia double,
    moTa varchar(255)
);

create table dongXe(
	dongXe varchar(255) primary key,
    hangXe varchar(255),
    soChoNgoi int
);

create table dangKyCungCap(
	maDKCC int primary key,
    
	maNhaCC int,
	maLoaiDV int,
	maMucPhi int,
	dongXe varchar(255),
    
    ngayBatDau date,
    ngayKetThuc date,
    soLuongXeDK int,
    
    foreign key(maNhaCC) references nhacungcap(maNhaCC),
    foreign key(maLoaiDV) references loaiDichVu(maLoaiDV),
    foreign key(maMucPhi) references mucPhi(maMucPhi),
    foreign key(dongXe) references dongXe(dongXe)
);



-- Câu 3: Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
select * from dongxe
where sochongoi > 4;

-- Câu 4: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
-- thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe
-- thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km

select * 
from nhacungcap join dangKyCungCap on nhacungcap.maNhaCC = dangKyCungCap.maNhaCC
				join dongxe on dangKyCungCap.dongxe = dongxe.dongxe
				join mucphi on mucphi.mamucphi = dangKyCungCap.mamucphi
where (hangxe = 'Toyota' and dongia = 100) or (hangxe = 'Kia' and dongia = 200);

-- Câu 5: Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung cấp và giảm dần theo mã số thuế
select * 
from nhacungcap
order by tennhacc asc,masothue desc;

-- Câu 6: Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
-- yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
-- cung cấp là “20/11/2015”

select tenNhaCC, count(tenNhaCC)
from nhacungcap join dangKyCungCap on nhacungcap.maNhaCC = dangKyCungCap.maNhaCC
where ngayBatDau >= '2021-5-5'
group by tenNhaCC;

-- Câu 7: Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe
-- chỉ được liệt kê một lần

select hangxe 
from dongxe
group by hangxe;

-- Câu 8: show tất cả các lần đăng ký cung cấp phương tiện với yêu 
-- cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương
-- tiện thì cũn
select * 
from nhacungcap  left join dangKyCungCap on nhacungcap.maNhaCC = dangKyCungCap.maNhaCC
				 left join dongxe on dangKyCungCap.dongxe = dongxe.dongxe
				 left join mucphi on mucphi.mamucphi = dangKyCungCap.mamucphi;
                 
-- Câu 9: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
-- thuộc dòng xe “Toyota” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Hundai”

select nhacungcap.*
from nhacungcap join dangKyCungCap on nhacungcap.maNhaCC = dangKyCungCap.maNhaCC
				join dongxe on dangKyCungCap.dongxe = dongxe.dongxe
Where hangxe = 'Toyota' or hangxe = 'hundai';

-- Câu 10: Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp phương tiện lần nào cả.
select *
from nhacungcap left join dangKyCungCap on nhacungcap.maNhaCC = dangKyCungCap.maNhaCC
where maDKCC is null
                 
                 
