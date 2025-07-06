<?php
session_start();
require 'C:\xampp\htdocs\Laptopku\config.php';

if (!isset($_SESSION['id_user'])) {
    echo json_encode(['success' => false, 'message' => 'User  not logged in']);
    exit();
}

//update saat qty ditambah atau berkurang
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $id_cart = $data['id_cart'];
    $action = $data['action'];

    try {
        if ($action === 1) { // Increase quantity
            $sql = "UPDATE cart SET quantity = quantity + 1 WHERE id_cart = :id_cart";
        } else if ($action === -1) { // Decrease quantity
            $sql = "UPDATE cart SET quantity = quantity - 1 WHERE id_cart = :id_cart AND quantity > 1";
        }

        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':id_cart', $id_cart, PDO::PARAM_INT);
        $stmt->execute();

        echo json_encode(['success' => true]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
}
?>