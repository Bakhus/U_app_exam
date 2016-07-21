
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
