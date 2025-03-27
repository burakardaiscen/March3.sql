-- 1. Books tablosundaki tüm kitapları listeleyen sorgu
SELECT * FROM Books;

-- 2. Yalnızca "Bilgisayar Bilimleri" kategorisindeki kitapları listeleyen sorgu
SELECT * FROM Books 
WHERE category = 'Bilgisayar Bilimleri';

-- 3. 2020 ve sonrasında yayımlanan kitapları listeleyen sorgu
SELECT * FROM Books 
WHERE publication_year >= 2020
ORDER BY publication_year ASC;

-- 4. Her kitabın ismini ve ait olduğu kategoriyi listeleyen sorgu
SELECT book_name, category FROM Books
ORDER BY category, book_name;

-- 5. Kitap alan öğrencilerin adını, soyadını ve kitap adını listeleyen sorgu
SELECT Students.first_name, Students.last_name, Books.book_name 
FROM BorrowedBooks
INNER JOIN Students ON BorrowedBooks.student_id = Students.student_id
INNER JOIN Books ON BorrowedBooks.book_id = Books.book_id
ORDER BY Students.last_name;

-- 6. Her kitapla ilişkili yazarı ve yayın yılını listeleyen sorgu
SELECT Books.book_name, Authors.author_name, Books.publication_year 
FROM Books
INNER JOIN Authors ON Books.author_id = Authors.author_id
ORDER BY Books.publication_year DESC;

-- 7. Hangi kullanıcı hangi kitabı ne zaman almış?
SELECT Students.first_name, Students.last_name, Books.book_name, BorrowedBooks.borrow_date 
FROM BorrowedBooks
INNER JOIN Students ON BorrowedBooks.student_id = Students.student_id
INNER JOIN Books ON BorrowedBooks.book_id = Books.book_id
ORDER BY BorrowedBooks.borrow_date DESC;

-- 8. Geri dönüş tarihi boş olan kitapların listesini ve kullanıcı bilgilerini getiriniz
SELECT Students.first_name, Students.last_name, Books.book_name, BorrowedBooks.borrow_date 
FROM BorrowedBooks
INNER JOIN Students ON BorrowedBooks.student_id = Students.student_id
INNER JOIN Books ON BorrowedBooks.book_id = Books.book_id
WHERE BorrowedBooks.return_date IS NULL
ORDER BY BorrowedBooks.borrow_date;

-- 9. Her kategoriye ait kaç kitap olduğunu listeleyiniz
SELECT category, COUNT(*) AS book_count 
FROM Books
GROUP BY category
ORDER BY book_count DESC;

-- 10. En çok kitap ödünç alan kullanıcıları en fazla borç alandan az borç alana göre sıralayınız
SELECT Students.first_name, Students.last_name, COUNT(BorrowedBooks.book_id) AS total_borrowed 
FROM BorrowedBooks
INNER JOIN Students ON BorrowedBooks.student_id = Students.student_id
GROUP BY Students.first_name, Students.last_name
HAVING COUNT(BorrowedBooks.book_id) > 0
ORDER BY total_borrowed DESC;

-- A) ALTER TABLE kullanımı
-- Bir tabloya yeni sütun ekleme
ALTER TABLE Books
ADD COLUMN page_count INT AFTER publication_year;

-- Bir sütunu değiştirme (veri tipi güncelleme)
ALTER TABLE Books
MODIFY COLUMN publication_year YEAR NOT NULL;

-- B) UPDATE, DELETE kullanımı
-- UPDATE kullanımı: Bir kitabın kategori bilgisini güncelleme
UPDATE Books
SET category = 'Yazılım'
WHERE book_name = 'Python Programlama';

-- DELETE kullanımı: Belirli bir kitabı silme
DELETE FROM Books
WHERE book_name = 'Eski Kitap'
LIMIT 1;

-- C) INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN farkları
-- INNER JOIN: Her iki tabloda eşleşen verileri getirir
SELECT Students.first_name, BorrowedBooks.borrow_date
FROM Students
INNER JOIN BorrowedBooks ON Students.student_id = BorrowedBooks.student_id;

-- LEFT JOIN: Sol (ilk) tablodaki tüm kayıtları ve sağ tabloda eşleşenleri getirir
SELECT Students.first_name, BorrowedBooks.borrow_date
FROM Students
LEFT JOIN BorrowedBooks ON Students.student_id = BorrowedBooks.student_id;

-- RIGHT JOIN: Sağ (ikinci) tablodaki tüm kayıtları ve sol tabloda eşleşenleri getirir
SELECT Students.first_name, BorrowedBooks.borrow_date
FROM Students
RIGHT JOIN BorrowedBooks ON Students.student_id = BorrowedBooks.student_id;

-- FULL OUTER JOIN: Her iki tablodaki tüm verileri getirir
SELECT Students.first_name, BorrowedBooks.borrow_date
FROM Students
LEFT JOIN BorrowedBooks ON Students.student_id = BorrowedBooks.student_id
UNION
SELECT Students.first_name, BorrowedBooks.borrow_date
FROM Students
RIGHT JOIN BorrowedBooks ON Students.student_id = BorrowedBooks.student_id;

-- D) HAVING ve GROUP BY birlikte kullanımı
-- Kategorisinde 3'ten fazla kitap olan kategorileri listeleme
SELECT category, COUNT(*) AS book_count
FROM Books
GROUP BY category
HAVING COUNT(*) > 3
ORDER BY book_count DESC;

-- E) TOP, OFFSET-FETCH kullanımı
-- İlk 5 kitabı getirme
SELECT * FROM Books
ORDER BY publication_year DESC
LIMIT 5;

-- OFFSET-FETCH (SQL Server için)
SELECT * FROM Books
ORDER BY publication_year DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- F) SUBQUERY (Alt Sorgu) kullanımı
-- 2020'den sonra yayımlanan kitapları alan kullanıcıları listeleme
SELECT Students.first_name, Students.last_name
FROM Students
WHERE student_id IN (
    SELECT student_id
    FROM BorrowedBooks
    INNER JOIN Books ON BorrowedBooks.book_id = Books.book_id
    WHERE Books.publication_year >= 2020
);

-- G) AND / OR mantıksal operatörleri kullanımı
-- 2020 sonrası yayımlanan ve 'Bilgisayar Bilimleri' kategorisindeki kitapları listeleme
SELECT * FROM Books
WHERE publication_year >= 2020 AND category = 'Bilgisayar Bilimleri';

-- 2020 sonrası yayımlanan veya 'Bilgisayar Bilimleri' kategorisindeki kitapları listeleme
SELECT * FROM Books
WHERE publication_year >= 2020 OR category = 'Bilgisayar Bilimleri';

-- H) BETWEEN ile aralık filtrelemesi
-- 2020 ile 2023 arasında yayımlanan kitapları listeleme
SELECT * FROM Books
WHERE publication_year BETWEEN 2020 AND 2023
ORDER BY publication_year;

-- I) IN ifadesiyle çoklu değer karşılaştırması
-- Belirli kategorilerdeki kitapları listeleme
SELECT * FROM Books
WHERE category IN ('Bilgisayar Bilimleri', 'Yazılım', 'Veritabanı');

-- J) LIKE operatörü kullanımı
-- 'SQL' kelimesini içeren kitapları listeleme
SELECT * FROM Books
WHERE book_name LIKE '%SQL%';

-- 'P' harfiyle başlayan kitapları listeleme
SELECT * FROM Books
WHERE book_name LIKE 'P%';

-- Üçüncü karakteri 'y' olan kitapları listeleme
SELECT * FROM Books
WHERE book_name LIKE '__y%';
