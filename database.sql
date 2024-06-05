CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE subscription_status AS ENUM ('active', 'pending', 'cancelled', 'completed');
CREATE TYPE payment_state AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE program_completion_status AS ENUM ('active', 'completed', 'pending', 'cancelled');
CREATE TYPE article_status AS ENUM ('created', 'in moderation', 'published', 'archived');



CREATE TABLE Programs (
    id SERIAL PRIMARY KEY,
    modul_id BIGINT REFERENCES Modules(id),
    name VARCHAR(255) NOT NULL,
    price BIGINT,
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
    program_id BIGINT REFERENCES Programs(id),
    course_id BIGINT REFERENCES Cources(id),
    deleted_at TIMESTAMP
);

CREATE TABLE Courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    module_id BIGINT REFERENCES Modules(id)
);

CREATE TABLE Lessons (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    video_url VARCHAR(255),
    position INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP,
    course_id BIGINT REFERENCES Courses(id)
);

CREATE TABLE ProgramModules (
    program_id BIGINT REFERENCES Programs(id),
    modules_id BIGINT REFERENCES Modules(id)
);

CREATE TABLE CoursesModules (
    courses_id BIGINT REFERENCES Courses(id),
    modules_id BIGINT REFERENCES Modules(id)
);


CREATE TABLE TeachingGroups (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    teaching_group_id BIGINT REFERENCES TeachingGroup(id),
    role user_role NOT NULL
);




CREATE TABLE Enrollments (
    id SERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id),
    program_id BIGINT REFERENCES Programs(id),
    status subscription_status NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Payments (
    id SERIAL PRIMARY KEY,
    enrollment_id BIGINT REFERENCES Enrollments(id)
    payment_amount BIGINT,
    status payment_state NOT NULL,
    date_of_payment TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProgramCompetions (
    id SERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id),
    program_id BIGINT REFERENCES Programs(id),
    status program_completion_status NOT NULL,
    start_program_completion TIMESTAMP,
    finish_program_completion TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP 
);
 
CREATE TABLE Certificates (
    id SERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES Users(id),
    program_id BIGINT REFERENCES Programs(id),
    certificate_url VARCHAR(255),   
    date_of_issue  TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Quizzes (
    id SERIAL PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Questions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    quiz_id BIGINT REFERENCES Quizzes(id) NOT NULL,
    parent_id BIGINT REFERENCES Questions(id),
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE AnswerOptions (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    question_id BIGINT REFERENCES Questions(id) NOT NULL,
    content TEXT,
    is_correct BOOLEAN,
    FOREIGN KEY (question_id) REFERENCES Questions(id)
);

CREATE TABLE Exercises (
    id SERIAL PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id),
    name VARCHAR(255),
    exercise_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Discussions (
    id SERIAL PRIMARY KEY,
    lesson_id BIGINT REFERENCES Lessons(id) NOT NULL,
    parent_id BIGINT REFERENCES Discussions(id),
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Blog (
    id SERIAL PRIMARY KEY,
    student_id BIGINT REFERENCES Students(id),
    title VARCHAR(255) UNIQUE,
    content TEXT,
    status article_status NOT NULL, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
