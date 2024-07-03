-- Create Authors table
CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(100)
);

-- Create Publishers table
CREATE TABLE Publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL,
    country VARCHAR(100)
);

-- Create Customers table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    address TEXT
);

-- Create Books table
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    publisher_id INT REFERENCES Publishers(publisher_id),
    publication_year INT
);

-- Create Orders table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT REFERENCES Customers(customer_id),
    total_amount NUMERIC(10, 2) NOT NULL
);

-- Create Book_Authors table
CREATE TABLE Book_Authors (
    book_id INT REFERENCES Books(book_id),
    author_id INT REFERENCES Authors(author_id),
    PRIMARY KEY (book_id, author_id)
);

-- Create Order_Items table
CREATE TABLE Order_Items (
    order_id INT REFERENCES Orders(order_id),
    book_id INT REFERENCES Books(book_id),
    PRIMARY KEY (order_id, book_id)
);
