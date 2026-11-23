<?php
require_once __DIR__.'/../config/database.php';require_once __DIR__.'/../config/auth.php';exigirLogin();
$id=(int)($_GET['id']??0);
try {
    $s=$pdo->prepare("DELETE FROM tutores WHERE id=?");
    $s->execute([$id]);
    header('Location: index.php?mensagem=excluido'); exit;
} catch(PDOException $e) {
    header('Location: index.php?mensagem=erro_vinculo'); exit;
}
header('Location: index.php');exit;
