
select city_name, percentile_disc(0.9) within group (order by time_diff)
over(partition by city_name) as time_diff_90
from (
      select table1.city_id, table2.city_name,
             (table1.actual_eta-table1.predicted_eta) as time_diff
      from trips as table1
      join cities as table2
      on table1.city_id=table2.city_name
      where table1.request_at > NOW() - INTERVAL '30' day;
      and table1.status = 'completed'
      and table2.city_name in ('Qarth','Meereen')
     )
group by city_name;

select city_name, percentile_disc(0.9) within group (order by time_diff) as time_diff_90
from (
      select table1.city_id, table2.city_name,
             (table1.actual_eta-table1.predicted_eta) as time_diff
      from trips as table1
      join cities as table2
      on table1.city_id=table2.city_id
      where table1.request_at > NOW() - INTERVAL '30 days'
      and table1.status = 'completed'
      and table2.city_name in ('Qarth','Meereen')
     )
group by city_name;



select table3.city_name,
       extract(DOW from table1._ts) as day_of_week,
       count(*) as prctg

from events as table1
join trips as table2
on table1.city_id = table2.city_id

join cities as table3
on table1.city_id=table3.city_id

where table1.event_name = 'sign_up_success'
and table1._ts BETWEEN '2016-01-01 00:00:00'::timestamp and '2016-01-08 00:00:00'::timestamp
and table3.city_name in ('Qarth','Meereen')
and DATEDIFF(hour, table1._ts, table2.request_at)<=168
and table2.status = 'completed'

group by 1,2;


select table2.city_name, table1.day_of_week, (100*sum(completed_trip)/count(*)) as sct_percentage
from
(
  select a.city_id, extract(DOW from a._ts) as day_of_week,
         CASE WHEN DATEDIFF(hour, a._ts, b.request_at)<=168 and b.status = 'completed'
              THEN 1
              ELSE 0
         END as completed_trip
  from events as a
  join trips as b
  on a.city_id = b.city_id
  where a.event_name = 'sign_up_success'
  and a._ts BETWEEN '2016-01-01 00:00:00'::timestamp and '2016-01-08 00:00:00'::timestamp
) as table1

join cities as table2
on table1.city_id=table2.city_id
and table2.city_name in ('Qarth','Meereen')
group  by  1, 2;
