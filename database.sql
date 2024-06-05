DROP TABLE IF EXISTS Modules, Programs, Courses, Lessons, ProgramModules, CourseModules, Users, TeachingGroups, Enrollments, Payments, ProgramCompetions, Certificates, Quizzes, Questions, Answers, Exercises, Discussions, Blog CASCADE;

DROP TYPE IF EXISTS article_status CASCADE;
DROP TYPE IF EXISTS program_completion_status CASCADE;
DROP TYPE IF EXISTS payment_state CASCADE;
DROP TYPE IF EXISTS subscription_status CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;


CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE subscription_status AS ENUM ('active', 'pending', 'cancelled', 'completed');
CREATE TYPE payment_state AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE program_completion_status AS ENUM ('active', 'completed', 'pending', 'cancelled');
CREATE TYPE article_status AS ENUM ('created', 'in moderation', 'published', 'archived');



CREATE TABLE Programs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    program_type VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Modules (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);



CREATE TABLE Courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Lessons (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    video_url VARCHAR(255),
    position INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP WITH TIME ZONE,
    course_id BIGINT REFERENCES Courses(id)
);

CREATE TABLE ProgramModules (
    program_id INT REFERENCES Programs(id),
    module_id INT REFERENCES Modules(id),
    PRIMARY KEY (program_id, module_id),
    FOREIGN KEY (program_id) REFERENCES Programs(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (module_id) REFERENCES Modules(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CourseModules (
    course_id INT REFERENCES Courses(id),
    module_id INT REFERENCES Modules(id),
    PRIMARY KEY (course_id, module_id),
    FOREIGN KEY (course_id) REFERENCES Courses(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (module_id) REFERENCES Modules(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255),
    teaching_group_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    role user_role NOT NULL
);


CREATE TABLE TeachingGroups (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Enrollments (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    program_id INT REFERENCES Programs(id),
    status subscription_status NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Payments (
    id SERIAL PRIMARY KEY,
    enrollment_id INT REFERENCES Enrollments(id),
    payment_amount INT,
    status payment_state NOT NULL,
    date_of_payment TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProgramCompetions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    program_id INT REFERENCES Programs(id),
    status program_completion_status NOT NULL,
    start_program_completion TIMESTAMP,
    finish_program_completion TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Certificates (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    program_id INT REFERENCES Programs(id),
    certificate_url VARCHAR(255),
    date_of_issue  TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Quizzes (
    id SERIAL PRIMARY KEY,
    lesson_id INT REFERENCES Lessons(id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Questions (
    id SERIAL PRIMARY KEY,
    quiz_id INT REFERENCES Quizzes(id) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Answers (
    id SERIAL PRIMARY KEY,
    question_id INT REFERENCES Questions(id) NOT NULL,
    content TEXT,
    is_correct BOOLEAN
);

CREATE TABLE Exercises (
    id SERIAL PRIMARY KEY,
    lesson_id INT REFERENCES Lessons(id),
    name VARCHAR(255),
    exercise_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Discussions (
    id SERIAL PRIMARY KEY,
    lesson_id INT REFERENCES Lessons(id) NOT NULL,
    parent_id INT REFERENCES Discussions(id),
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Blog (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Users(id),
    title VARCHAR(255) UNIQUE,
    content TEXT,
    status article_status NOT NULL, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

