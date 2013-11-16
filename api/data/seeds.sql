INSERT INTO users (id, full_name, user_type, email) VALUES
    (1, 'Government 2014', 'government', 'government@gov.ph');

INSERT INTO users (id, full_name, user_type, email) VALUES
    (2, 'Daryll', 'citizen', 'daryll@gov.ph');

INSERT INTO users (id, full_name, user_type, email) VALUES
    (3, 'Darll2', 'citizen', 'aryll2@gov.ph');

INSERT INTO categories (id, full_name, image) 
    VALUES (1, 'Social Services', 'social.png'),
            (2, 'Economic Services', 'economic.png'),
            (3, 'General Public Services', 'public.png'),
            (4, 'Debt Burden', 'debt.png'),
            (5, 'Defense', 'defense.png');

INSERT INTO allocations (user_id, category_id, budget_allocation, amount) 
    VALUES (1, 1, '37.2', '842800000'),
            (1, 2, '26.0', '590200000'),
            (1, 3, '16.1', '364500000'),
            (1, 4, '16.6', '377600000'),
            (1, 5, '4.1', '92900000');

INSERT INTO allocations (user_id, category_id, budget_allocation, amount) 
    VALUES (2, 1, '37.2', '842800000'),
            (2, 2, '26.0', '590200000'),
            (2, 3, '16.1', '364500000'),
            (2, 4, '16.6', '377600000'),
            (2, 5, '4.1', '92900000');

INSERT INTO allocations (user_id, category_id, budget_allocation, amount) 
    VALUES (3, 1, '97.2', '942800000'),
            (3, 2, '96.0', '990200000'),
            (3, 3, '96.1', '964500000'),
            (3, 4, '96.6', '977600000'),
            (3, 5, '9.1', '92900000');

INSERT INTO category_breakdowns (category_id, full_name, amount, unit, image)
    VALUES (5, 'Aircraft', '34.5M', 'per plane', 'jet.png'),
            (3, 'Carrier truck', '3.1M', '', 'truck.png'),
            (5, 'Flood control structure', '45.7 million', '', 'floodcontrol.png'),
            (5, 'Vehicular radio', '2.2M', '', 'radio.png'),

            (3, 'Business permit', '4464.4', '', 'businesspermit.png'),
            (3, 'NBI clearance', '149.9', '', 'nbi.png'),
            (3, 'Passport', '2407.1', '', 'passport.png'),
            (3, 'Visa', '328.2', '', 'visa.png'),

            (1, 'Health facility', '4.6M', '', 'hospital.png'),
            (1, 'Health worker', '117045', '', 'nurse.png'),
            (1, 'Classroom', '873028', '', 'school.png'),
            (1, 'Teacher', '259082', '', 'teacher.png'),
            (1, 'Textbook', '194.8', '', 'book.png'),

            (2, 'Road', '12M', 'per km', 'road.png'),
            (2, 'Seedling', '37.7', '', 'seedling.png'),
            (2, 'Fist port', '416', '', 'fishport.png'),
            (2, 'Fertilizer', '346.7', 'per sack', 'fertilizer.png'),
            (2, 'Livestock', '33.8', '', 'livestock.png'),

            (4, 'Debt', '337.6', 'total',  'debt.png');