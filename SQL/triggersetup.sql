
DROP TRIGGER IF EXISTS RIcode_check;
DROP TRIGGER IF EXISTS Review_resign;


-- 5reviewers interests
INSERT INTO `Reviewer_Interest` (`id_reviewer`,`interest_code_1`) VALUES (200,100);
INSERT INTO `Reviewer_Interest` (`id_reviewer`,`interest_code_1`,`interest_code_2`) VALUES (201,100,101);
INSERT INTO `Reviewer_Interest` (`id_reviewer`,`interest_code_1`,`interest_code_2`) VALUES (202,100,102);


-- 5 reviewers 200-204
INSERT INTO `Reviewer` (`id_reviewer`,`first_name`,`last_name`,`email`,`id_affiliation`,`password`,`enabled`) VALUES (200,"Denton","Moore","nec.ante.Maecenas@nibh.org",118,"8495",1);
INSERT INTO `Reviewer` (`id_reviewer`,`first_name`,`last_name`,`email`,`id_affiliation`,`password`,`enabled`) VALUES (201,"Inga","Stuart","ut.lacus.Nulla@erosnectellus.net",106,"5604",1);
INSERT INTO `Reviewer` (`id_reviewer`,`first_name`,`last_name`,`email`,`id_affiliation`,`password`,`enabled`) VALUES (202,"Inga","Stuart","ut.lacus.Nulla@erosnectellus.net",106,"5604",1);


INSERT INTO `Review_Decision` (`id_manuscript`,`id_reviewer`,`date_assigned`) VALUES (200,200,"2017-9-12");
INSERT INTO `Review_Decision` (`id_manuscript`,`id_reviewer`,`date_assigned`) VALUES (200,202,"2017-9-12");
INSERT INTO `Review_Decision` (`id_manuscript`,`id_reviewer`,`date_assigned`) VALUES (201,201,"2017-9-12");


INSERT INTO `Manuscript` (`id_manuscript`,`title`,`ri_code`,`status`,`date_received`,`date_last_status_changed`,`file`,`id_editor`) VALUES (200,"blandit viverra. , lorem fringilla ornare",100,1,"1969-12-31","1969-12-31","ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet.",100);
INSERT INTO `Manuscript` (`id_manuscript`,`title`,`ri_code`,`status`,`date_received`,`date_last_status_changed`,`file`,`id_editor`) VALUES (201,"volutpat. Nulla. Maecenas ornare egestas",101,1,"1969-12-31","1970-01-11","montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat",101);
