<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

$app = new Silex\Application();
$app['debug'] = true;

$app->register(new Silex\Provider\DoctrineServiceProvider(), array(
    // Doctrine DBAL settings goes here
    'db.options' => array(
        'driver' => 'pdo_mysql',
        'user' => 'root',
        'password' => '',
        'dbname' => 'angbudgetmo',
        'host' => 'localhost'
    )
));

$app->get('/hello', function() {
            return 'Hello!';
        });

$app->get('/users/{id}', function($id) use ($app) {
            $sql = "SELECT * FROM users WHERE users.id = ?";
            $user['user'] = reset($app['db']->fetchAll($sql, array((int) $id)));

            $sql = "SELECT categories.full_name as sector, 
                budget_allocation, amount, category_id, image
                    FROM users 
                    JOIN categories
                    JOIN allocations
                    ON allocations.category_id = categories.id
                    AND allocations.user_id = ?
                    WHERE users.id = ?";
            $user['allocations'] = $app['db']->fetchAll($sql, array((int) $user['user']['id'], (int) $user['user']['id']));

            $sql = "SELECT full_name, amount, unit, image
                    FROM category_breakdowns
                    WHERE category_id = ?";

            foreach ($user['allocations'] as $sector) {
                $user['allocations'][$sector['category_id'] - 1]['assignments'] = $app['db']->fetchAll($sql, array((int) $sector['category_id']));
            }

            return new response(json_encode($user), 201);
        });

$app->get('/people', function() use ($app) {
            $sql = "SELECT * FROM users WHERE users.id = 1";
            $people['user'] = reset($app['db']->fetchAll($sql));
            $sql = "SELECT user_id, category_id, AVG(budget_allocation) as budget_allocation, AVG(amount) as amount
                FROM allocations WHERE user_id > 1 GROUP BY category_id ";
            $people['allocations'] = $app['db']->fetchAll($sql);

//            $sql = "SELECT full_name, amount, unit, image
//                    FROM category_breakdowns
//                    WHERE category_id = ?";
//
//            foreach ($people['allocations'] as $sector) {
//                $people['allocations'][$sector['category_id'] - 1]['assignments'] = $app['db']->fetchAll($sql, array((int) $sector['category_id']));
//            }

            return new response(json_encode($people), 201);
        });

$app->post('/users', function (Request $request) use ($app) {
            $id = $request->get('id');
            $full_name = $request->get('full_name');
            $user_type = 'citizen';
            $email = $request->get('email');
//            Insert check if valid data
            $app['db']->insert('users', array('id' => $id , 'full_name' => $full_name, 'user_type' => $user_type, 'email' => $email));

            return new Response("User id $id inserted", 201);
        });
        
//        Must be well-formed and contain all 5
$app->post('/allocations', function (Request $request) use ($app) {
            $user_id = $request->get('user_id');
            $category_id = $request->get('category_id');
            $budget_allocation = $request->get('budget_allocation');
            $amount = $request->get('amount');
//            Insert check if valid data
            $app['db']->insert('allocations', array('user_id' => $user_id , 'category_id' => $category_id, 'budget_allocation' => $budget_allocation, 'amount' => $amount));

            return new Response("User id $user_id inserted", 201);
        });
        
$app->run();
