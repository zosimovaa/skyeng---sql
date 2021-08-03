SELECT 
      user_id
    , session_open
    , session_close
FROM
    (SELECT
          tb_sessions.session_id
        , avg(tb_pages.user_id) as user_id
        , min(tb_pages.happened_at) as session_open
        , max(tb_pages.happened_at) + interval '1 hour' as session_close
        , listagg(tb_pages.page, ', ') within group (order by tb_pages.happened_at asc) as pages
    FROM 
        test.vimbox_pages AS tb_pages
        left join
        (SELECT
              tb_actions2.user_id || '-' || row_number() over(partition by tb_actions2.user_id order by tb_actions2.happened_at) as session_id
            , tb_actions2.user_id
            , tb_actions2.page
            , tb_actions2.happened_at as session_start
            , nvl(lead(tb_actions2.happened_at) over(partition by tb_actions2.user_id order by tb_actions2.happened_at), GETDATE()) as next_session_start  
        FROM
            (SELECT
                  tb_actions.user_id  
                , tb_actions.page
                , tb_actions.happened_at
                , DATEDIFF(minutes, LAG(tb_actions.happened_at) OVER(PARTITION BY tb_actions.user_id ORDER BY tb_actions.happened_at), tb_actions.happened_at) AS inactivity_time
            FROM test.vimbox_pages AS tb_actions
          ) as tb_actions2
        WHERE (tb_actions2.inactivity_time > 60 OR tb_actions2.inactivity_time is null)
        ) as tb_sessions on (tb_pages.user_id = tb_sessions.user_id) and (tb_pages.happened_at>=tb_sessions.session_start) and (tb_pages.happened_at<tb_sessions.next_session_start)
    GROUP BY  tb_sessions.session_id 
    ) as tb_sessions_result
WHERE pages LIKE '%rooms.homework-showcase%rooms.view.step.content%rooms.lesson.rev.step.content%'
 