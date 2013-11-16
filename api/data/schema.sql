
/*drop database angbudgetmo;*/
create database angbudgetmo;
use angbudgetmo;

CREATE TABLE users(
	id int(11) auto_increment primary key,
	full_name varchar(64) not null,
	user_type varchar(64) not null, 
        email varchar(128) not null
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/* sectors?? */
CREATE TABLE categories(
	id int(11) auto_increment primary key,
        full_name varchar(64) not null,
        image varchar(64) not null
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE allocations(
        user_id int(11),
        category_id int(11),
        budget_allocation decimal not null,
        amount int not null,
        CONSTRAINT fk_allocations_users 
        FOREIGN KEY (user_id) REFERENCES users(id),
        CONSTRAINT fk_allocations_categories 
        FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE category_breakdowns(
        category_id int(11),
        full_name varchar(64) not null,
        amount decimal not null,
        unit varchar(64) not null,
        image varchar(64) not null,
        CONSTRAINT fk_category_breakdowns_categories 
        FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



