
-- clean involved table
-- trigger 1 test
-- case1: don't have RICode 110 , throw exception
INSERT INTO `Manuscript` (`id_manuscript`,`title`,`ri_code`,`status`,`date_received`,`date_last_status_changed`,`file`,`id_editor`) VALUES (203,"blandit viverra. , lorem fringilla ornare",110,1,"1969-12-31","1969-12-31","ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet.",100);
-- case2:  have RICode 100, insert successfully
INSERT INTO `Manuscript` (`id_manuscript`,`title`,`ri_code`,`status`,`date_received`,`date_last_status_changed`,`file`,`id_editor`) VALUES (204,"blandit viverra. , lorem fringilla ornare",100,1,"1969-12-31","1969-12-31","ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet.",100);


-- trigger 2 test
-- case1: no other reviewer have RICode 101, set status to rejected(2)
DELETE FROM `Review_Decision` WHERE `id_manuscript`='201' and`id_reviewer`='201';
-- case2: Manuscript 200 have another reviewer, do nothing
DELETE FROM `Review_Decision` WHERE `id_manuscript`='200' and`id_reviewer`='202';
-- case2: Manuscript 200 have no reviewer, but have other reviewer with RIcode 200,set status to submitted(0)
DELETE FROM `Review_Decision` WHERE `id_manuscript`='200' and`id_reviewer`='200';