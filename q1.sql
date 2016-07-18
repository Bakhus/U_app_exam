
select city_name, percentile_disc(0.9) within group (order by time_diff)
over(partition by city_name) as 'time_diff_90'
from (
      select table1.city_id, table2.city_name,
             (table1.actual_eta-table1.predicted_eta) as 'time_diff'
      from trips as table1
      join cities as table2
      on table1.city_id=table2.city_name
      where table1.request_at > NOW() - INTERVAL '30 days';
      and table1.status = 'completed'
      and table2.city_name in ('Qarth','Meereen')
     )
group by city_name;
