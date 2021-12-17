create table test(
	testID int primary key,
    name varchar(50)
);

create table student(
	RN int primary key,
    name varchar(50),
    age int,
    status bit
);

create table studenttest(
	RN int,
	testID int,
    date date,
    mark int,
    primary key(RN, testID),
	Foreign key (RN) references student(RN),
	Foreign key (testID) references test(testID)
);

-- Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. 
-- Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần
select student.name, avg(mark) as avgt
from studenttest join student on studenttest.RN = student.RN
group by student.name
order by avgt desc

-- Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất 

create view avg
as
select student.name, avg(mark) as avgt
from studenttest join student on studenttest.RN = student.RN
group by student.name;


select student.name, avg(mark) as avgt
from studenttest join student on studenttest.RN = student.RN
group by student.name
having avgt = (select max(avgt)
			   from avg)

-- Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học
select test.name, max(mark)
from studenttest join test on studenttest.testID = test.testID
group by test.name
order by test.name;

-- Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó 
-- đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null 
select *
from studenttest join test on studenttest.testID = test.testID
				right join student on studenttest.RN = student.RN;

                
-- Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student
set age = age + 1 
where RN > 0;

-- Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student
change status status varchar(50);

UPDATE student SET age = '50' WHERE (RN = '1');

-- Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 
-- 30 tuổi sẽ nhận giá trị ‘Young’,trường hợp còn lại nhận giá trị ‘Old’

update student
set status = (case when age > 30 then 'Old' else 'Young' end)
where RN > 0;

-- Tạo view tên là vwStudentTestList hiển thị danh sách học viên và điểm thi
-- , dánh sách phải sắp xếp tăng dần theo ngày thi

create view vwStudentTestList
as
select student.*, mark
from studenttest join student on studenttest.RN = student.RN
order by date;

select *
from vwStudentTestList;

-- Tạo một trigger tên là tgSetStatus sao cho khi sửa tuổi của
--  học viên thi trigger này sẽ tự động cập nhật status
DELIMITER $$
CREATE TRIGGER tgSetStatus 
 before UPDATE on student
 FOR EACH ROW
BEGIN
	if (new.age < 30)
    then
		set new.status = 'Young';
	else
		set new.status = 'old';
    end if;
END$$

-- Tạo một stored procedure tên là spViewStatus, stored procedure này nhận vào 2 tham số
-- Tham số thứ nhất là tên học viên					
-- Tham số thứ 2 là tên môn học
-- Hiển thị ‘Chua thi’ nếu học viên đó chưa thi môn đó
-- Hiển thị ‘Do’ nếu đã thi rồi và điểm lơn hơn hoặc bằng 5
-- Hiển thị ‘Trượt’ nếu đã thi rồi và điểm thi nhỏ hơn 5


DELIMITER $$
CREATE procedure spViewStatus(nameHV varchar(50),nameMH varchar(50))
BEGIN
	select student.name, test.name, (case when mark > 5 then 'qua môn' when mark < 5 then 'trượt' else 'chưa thi' end) as 'học lực'
    from studenttest join test on studenttest.testID = test.testID
				right join student on studenttest.RN = student.RN
	where (student.name = nameHV and test.name = nameMH) or student.name = nameHV;
END$$

call spViewStatus('Toàn', 'Toán');
call spViewStatus('Lan', 'Toán');
call spViewStatus('Nam', 'Toán');



