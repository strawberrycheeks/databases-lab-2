<!doctype html>
<html lang="ru">
<head>
	<meta charset="UTF-8" />
	<title>Отчёт для печати</title>
	<meta name="description" content="Отчёт для печати" /> 
    <meta name="Keywords" content="ОТЧЁТ, ПЕЧАТЬ" />
  	<link rel="stylesheet" href="style/print.css" />
    <link rel="shortcut icon" href="image/favicon.ico" type="image/x-icon" />
</head>
<body>
	<header>
		<h3>&nbsp;</h3>
	</header>
	<content>	
		<main>
					
			<form action="" method="get">
			<table class="c2" style="width:650px">
			<tr><td class="c2">Печать результата процедуры <br />MergeTables из MySQL<br /> для таблиц NaturalObject и Observation</td></tr>
			</table>
			
			<table>
			
			<tr class="cH">
				<td>id</td>
				<td>type</td>
				<td>galaxy</td>
				<td>accuracy</td>
				<td>flux</td>
				<td>associated</td>
				<td>notes</td>
        <td>ntob_id</td>
				<td>sctr_id</td>
				<td>obj_id</td>
				<td>pos_id</td>
			</tr>	

<?php 
// блок инициализации
try {
	$pdoSet = new PDO('mysql:dbname=astronomydb;host=localhost', 'root', '');
	$pdoSet->query('SET NAMES utf8;');
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}

	// $sqlTM="SELECT * FROM naturalobject ORDER BY id ASC";  // ASC - по возрастанию; DESC - по убыванию.
  // $stmt = $pdoSet->query($sqlTM);
	// $resultMF = $stmt->fetchAll();

  $table1_name = 'NaturalObject';
  $table2_name = 'Observation';

  $resultMF = []; // Инициализация переменной

  try {
      // Вызов процедуры MergeTables для объединения двух таблиц для печати
      $stmt = $pdoSet->prepare("CALL MergeTables(?, ?)");
      $stmt->bindParam(1, $table1_name, PDO::PARAM_STR);
      $stmt->bindParam(2, $table2_name, PDO::PARAM_STR);

      $stmt->execute();

      // Извлечение всех строк из результата
      $resultMF = $stmt->fetchAll(PDO::FETCH_ASSOC);

  } catch (Exception $e) {
      echo "Ошибка: " . $e->getMessage();
  }

  // Проверка, не пуст ли результат
  if ($resultMF) {
      // Вывод данных
      foreach ($resultMF as $row) {
          echo '<tr>';
          foreach ($row as $column) {
              echo '<td>' . htmlspecialchars($column) . '</td>';
          }
          echo '</tr>';
      }
  } else {
      echo "Нет данных для отображения.";
  }
	
?>
				</table>
			</form>
		</main>
	</content>
	<footer>
		<div>&nbsp;</div> 
	</footer>	
</body>
</html>