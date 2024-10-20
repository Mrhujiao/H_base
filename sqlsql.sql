use student_system;

select *
from student;

select *
from course;

with S_N_I_C as (
    select student.name,student.student_id,student.my_class
    from student
)
select * from S_N_I_C;

select teacher.name,teacher.title
from teacher;

with C_avgS as (
    select course.course_name,score.score
    from course,score
    where score.course_id = course.course_id
)
select course_name,avg(C_avgS.score)
from C_avgS
group by C_avgS.course_name;

with S_avgS as (
    select score.student_id,avg(score.score) as avg_S
    from score
    group by student_id
)
select student.name,avg_S
from S_avgS,student
where S_avgS.student_id = student.student_id;

select score.student_id,score.course_id
from score
where score.score > 85;

select score.course_id,count(score.student_id)
from score
group by course_id;


with M_SI_S as (
    select score.student_id,score.score
    from score
    where course_id in (
    select course.course_id
    from course
    where course_name = '高等数学'
        )
)
select student.name,M_SI_S.score
from student,M_SI_S
where M_SI_S.student_id = student.student_id;

with N_P as(
  select distinct score.student_id
  from score
  where student_id not in(
        select distinct score.student_id
        from score,course
        where course.course_id = score.course_id and course_name = '大学物理'
      )
)
select distinct student.name
from student,N_P
where N_P.student_id = student.student_id;


select s1.student_id, student.name, student.gender, student.birth_date, my_class,s1.score,s2.score
from student,score s1,score s2
where s1.course_id = 'C001' and s2.course_id = 'C002' and s1.student_id = s2.student_id and s1.student_id= student.student_id and s1.score > s2.score;

select score.course_id,course.course_name,
       CAST(SUM(CASE WHEN score.score > 85 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100,
       CAST(SUM(CASE WHEN score.score between 85 and 70 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100,
       CAST(SUM(CASE WHEN score.score between 70 and 60 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100,
       CAST(SUM(CASE WHEN score.score between 60 and 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100
from score,course
where score.course_id = course.course_id
group by score.course_id;

with high_avg as (
    select score.student_id,avg(score.score) as avg_score
    from score
    group by score.student_id
)
select s.name, ha.avg_score as max_avg_score
from high_avg ha
join student s on ha.student_id = s.student_id
where ha.avg_score = (select max(avg_score) from high_avg);

with topthree_sum as (
    select score.student_id,sum(score.score) as sum_score
    from score
    group by score.student_id
)
select s.name,sum_score
from topthree_sum
join student s on topthree_sum.student_id = s.student_id
order by sum_score desc limit 3;

with SC_CaCu as (
    select score.course_id,c.course_name,
           MAX(score.score) AS max_score,
           MIN(score.score) AS min_score,
           AVG(score.score) AS avg_score,
           SUM(CASE WHEN score.score >= 60 THEN 1 ELSE 0 END) / COUNT(*) AS pass_rate,
           SUM(CASE WHEN score.score >= 70 and score.score <= 79.5 THEN 1 ELSE 0 END) / COUNT(*) AS medium_rate,
           SUM(CASE WHEN score.score >= 80 and score.score <= 89.5 THEN 1 ELSE 0 END) / COUNT(*) AS good_rate,
           SUM(CASE WHEN score.score >= 90 THEN 1 ELSE 0 END) / COUNT(*) AS excellent_rate,
           count(score.student_id) as count_St
    from score
    join student_system.course c on c.course_id = score.course_id
    group by score.course_id
)
select SC_CaCu.course_id as '课程ID',
       SC_CaCu.course_name as '课程name',
       SC_CaCu.max_score as '最高分',
       SC_CaCu.min_score as '最低分',
       SC_CaCu.avg_score as '平均分',
       SC_CaCu.pass_rate as '及格率',
       SC_CaCu.medium_rate as '中等率',
       SC_CaCu.good_rate as '优良率',
       SC_CaCu.excellent_rate as '优秀率',
       SC_CaCu.count_St as '选修人数',
rank() over (order by count_St DESC ,course_id asc) as '排名'
from SC_CaCu;

以下是将上述 SQL 语句中的关键字转换为小写后的内容：

-- 学生相关
select gender, count(*) as count
from student
group by gender;

select name
from student
where birth_date = (select min(birth_date) from student);

select name
from teacher
where birth_date = (select max(birth_date) from teacher);

select s.*
from student s
         join score sc on s.student_id = sc.student_id
         join course c on sc.course_id = c.course_id
         join teacher t on c.teacher_id = t.teacher_id
where t.name = '张教授';

select s.*
from student s
         join score sc on s.student_id = sc.student_id
where sc.course_id in (select course_id from score where student_id = '2021001')
  and s.student_id!= '2021001';

select c.course_name, avg(sc.score) as average_score
from course c
         join score sc on c.course_id = sc.course_id
group by c.course_id
order by average_score desc;

select c.course_name, sc.score
from score sc
         join course c on sc.course_id = c.course_id
where sc.student_id = '2021001';

select s.name, c.course_name, sc.score
from student s
         join score sc on s.student_id = sc.student_id
         join course c on sc.course_id = c.course_id;

select t.name, avg(sc.score) as average_score
from teacher t
         join course c on t.teacher_id = c.teacher_id
         join score sc on c.course_id = sc.course_id
group by t.teacher_id;

select s.name, c.course_name
from student s
         join score sc on s.student_id = sc.student_id
where sc.score between 80 and 90;

select s.my_class, avg(sc.score) as average_score
from student s
         join score sc on s.student_id = sc.student_id
group by s.my_class;

select s.name
from student s
where s.student_id not in (
    select sc.student_id
    from score sc
             join course c on sc.course_id = c.course_id
             join teacher t on c.teacher_id = t.teacher_id
    where t.name = '王讲师'
);

select s.student_id, s.name, avg(sc.score) as average_score
from student s
         join score sc on s.student_id = sc.student_id
where sc.score < 85
group by s.student_id, s.name
having count(sc.course_id) >= 2;

select s.student_id, s.name, sum(sc.score) as total_score
from student s
         join score sc on s.student_id = sc.student_id
group by s.student_id, s.name
order by total_score desc;

select c.course_name
from course c
         join score sc on c.course_id = sc.course_id
group by c.course_id
having avg(sc.score) > 85;

select s.student_id, s.name, avg(sc.score) as average_score,
       @rank := @rank + 1 as ranking
from student s
         join score sc on s.student_id = sc.student_id,
     (select @rank := 0) as init
group by s.student_id, s.name
order by average_score desc;

select c.course_name, s.name, sc.score
from course c
         join score sc on c.course_id = sc.course_id
         join student s on sc.student_id = s.student_id
where (c.course_id, sc.score) in (
    select course_id, max(score)
    from score
    group by course_id
);

select s.name
from student s
         join score sc on s.student_id = sc.student_id
         join course c on sc.course_id = c.course_id
where c.course_name in ('高等数学', '大学物理')
group by s.student_id
having count(distinct c.course_name) = 2;

select s.student_id, s.name, c.course_name, sc.score, avg(sc.score) over (partition by s.student_id) as average_score
from student s
         left join score sc on s.student_id = sc.student_id
         left join course c on sc.course_id = c.course_id
order by average_score desc, s.student_id, c.course_name;

select s.name, sc.score
from student s
         join score sc on s.student_id = sc.student_id
where sc.score = (select max(score) from score)
union all
select s.name, sc.score
from student s
         join score sc on s.student_id = sc.student_id
where sc.score = (select min(score) from score);

select s.my_class, max(sc.score) as max_score, min(sc.score) as min_score
from student s
         join score sc on s.student_id = sc.student_id
group by s.my_class;

select c.course_name, count(case when sc.score >= 90 then 1 end) / count(sc.score) as excellent_rate
from course c
         join score sc on c.course_id = sc.course_id
group by c.course_name;

select s.student_id, s.name, avg(sc.score) as average_score
from student s
         join score sc on s.student_id = sc.student_id
group by s.student_id, s.name
having avg(sc.score) > (select avg(score) from score where student_id in (select student_id from student where my_class = s.my_class));

select s.student_id, s.name, c.course_name, sc.score, sc.score - avg(sc.score) over (partition by c.course_id) as difference
from student s
         join score sc on s.student_id = sc.student_id
         join course c on sc.course_id = c.course_id;

-- 员工相关
use employee_management;

select first_name, last_name, email, job_title
from employees;

select dept_name, location
from departments;

select first_name, last_name, salary
from employees
where salary > 70000;

select e.first_name, e.last_name
from employees e
join departments d on e.dept_id = d.dept_id
where d.dept_name = 'it';

select e.first_name, e.last_name
from employees e
join departments d on e.dept_id = d.dept_id
where d.dept_name = 'it';

select *
from employees
where hire_date > '2020-01-01';

select d.dept_name, avg(e.salary) as average_salary
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_name;

select *
from employees
order by salary desc
limit 3;

select d.dept_name, count(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id = e.dept_id
group by d.dept_name;

select *
from employees
where dept_id is null;

select e.emp_id, e.first_name, e.last_name, count(ep.project_id) as project_count
from employees e
left join employee_projects ep on e.emp_id = ep.emp_id
group by e.emp_id, e.first_name, e.last_name
order by project_count desc
limit 1;

select sum(salary) as total_salary
from employees;

select *
from employees
where last_name = 'smith';

select *
from projects
where end_date between curdate() and date_add(curdate(), interval 6 month);

select e.emp_id, e.first_name, e.last_name
from employees e
join employee_projects ep on e.emp_id = ep.emp_id
group by e.emp_id, e.first_name, e.last_name
having count(ep.project_id) >= 2;

select e.emp_id, e.first_name, e.last_name
from employees e
left join employee_projects ep on e.emp_id = ep.emp_id
where ep.project_id is null;

select project_id, count(emp_id) as employee_count
from employee_projects
group by project_id;

select *
from employees
order by salary desc
limit 1 offset 1;

select d.dept_name, e.first_name, e.last_name, e.salary
from departments d
join employees e on d.dept_id = e.dept_id
where (d.dept_id, e.salary) in (
    select dept_id, max(salary)
    from employees
    group by dept_id
);

select d.dept_name, sum(e.salary) as total_salary
from departments d
join employees e on d.dept_id = e.dept_id
group by d.dept_name
order by total_salary desc;

select e.first_name, e.last_name, d.dept_name, e.salary
from employees e
join departments d on e.dept_id = d.dept_id;

select e.emp_id, e.first_name, e.last_name, mgr.emp_id as manager_emp_id, mgr.first_name as manager_first_name, mgr.last_name as manager_last_name
from employees e
left join employees mgr on e.dept_id = mgr.dept_id and mgr.emp_id < e.emp_id and not exists (
    select 1 from employees sub_mgr where sub_mgr.dept_id = e.dept_id and sub_mgr.emp_id < mgr.emp_id
);

select distinct job_title
from employees;

select d.dept_name
from departments d
join (
    select dept_id, avg(salary) as avg_salary
    from employees
    group by dept_id
    order by avg_salary desc
    limit 1
) as sub on d.dept_id = sub.dept_id;

select e.emp_id, e.first_name, e.last_name, e.salary, sub.avg_salary
from employees e
join (
    select dept_id, avg(salary) as avg_salary
    from employees
    group by dept_id
) as sub on e.dept_id = sub.dept_id
where e.salary > sub.avg_salary;

select e.dept_id, e.emp_id, e.first_name, e.last_name, e.salary
from employees e
where (e.dept_id, e.salary) in (
    select dept_id, salary
    from (
        select dept_id, salary,
            row_number() over (partition by dept_id order by salary desc) as ranking
        from employees
    ) as sub
    where ranking <= 2
);

