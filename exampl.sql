/*Создаем таблицы для работы*/


CREATE TABLE author(author_id INT PRIMARY KEY AUTO_INCREMENT, 
name_author VARCHAR(50));
INSERT into author(name_author) values('Булгаков М.А.'),
('Достоевский Ф.М.'),
('Есенин С.А.'),
('Пастернак Б.Л.');


CREATE TABLE genre (genre_id INT PRIMARY KEY AUTO_INCREMENT, 
name_genre VARCHAR(30));
INSERT into genre(name_genre) values('Романс'),
('Поэма'),
('Проза'),
('Стихи');


CREATE TABLE book (
      book_id INT PRIMARY KEY AUTO_INCREMENT, 
      title VARCHAR(50), 
      author_id INT,
      genre_id INT,
      price DECIMAL(8,2), 
      amount INT, 
      FOREIGN KEY (author_id)  REFERENCES 
      author (author_id) ON DELETE CASCADE, 
      FOREIGN KEY (genre_id)  REFERENCES 
      genre (genre_id) ON DELETE SET NULL);
INSERT into book( title, author_id, genre_id, price, amount) value  
('Мастер и Маргарита', 1, 1, 670.99, 3),
('Белая гвардия', 1, 1, 540.50, 5),
('Идиот', 2, 1, 460.00, 10),
('Братья Карамазовы', 2, 1, 799.01, 3),
('Игрок', 2, 1, 480.50, 10),
('Стихотворения и поэмы', 3, 1, 650.00, 15),
('Черный человек', 3, 2, 570.20, 6),
('Лирика', 4, 2, 518.99, 2);    




/*Вывести таблицу жанров где второй столбец - количество авторов, 
пишущих в этих жанрах, а третьим - количество книг этого жанра*/

SELECT name_genre,
       COUNT(DISTINCT author.author_id) AS "Количество авторов жанра",
       SUM(amount) AS "Количество книг жанра"
FROM author INNER JOIN book
     ON author.author_id = book.author_id
     INNER JOIN genre
     ON genre.genre_id= book.genre_id
GROUP BY name_genre;

/*Сделать инвентаризацию на складе. 
Выяснить сколько книг каждого автора, 
жанр каждого произведения и посчитать сколько денег потрачено на покупку. 
Отсортировать по уменьшению затрат по каждому наименованию . 
Авторов отсортировать по алфавиту.*/

SELECT author.name_author AS Автор, title AS Название, genre.name_genre AS Жанр, 
price AS Цена, amount AS Количество, price*amount AS Стоимость
FROM genre INNER JOIN book 
ON genre.genre_id=book.genre_id
    INNER JOIN author
    ON book.author_id=author.author_id 
    ORDER BY 1, 6 DESC;


/*
Для каждого автора из таблицы author вывести количество книг, написанных им в каждом жанре.
Вывод: ФИО автора, жанр, количество. Отсортировать по фамилии, затем - по убыванию количества написанных книг.
*/

SELECT  name_author, name_genre, COUNT(title) Количество
FROM book RIGHT JOIN (SELECT  name_author, name_genre, author_id, genre_id
                      FROM author CROSS JOIN genre) AS author_genre USING(author_id, genre_id)
GROUP BY name_author, name_genre
ORDER BY name_author, Количество DESC; 


/*
Изменить для книги «Стихотворения и поэмы»  жанр «Поэма»,
  а для книги «Игрок»  - «Стихи». .
*/

UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Поэма')
WHERE book_id = 6;

UPDATE book
SET genre_id = (SELECT genre_id 
                FROM genre 
                WHERE name_genre = 'Стихи')
WHERE book_id = 5;

SELECT * FROM book;
