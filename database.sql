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
    id SERIAL [pk],
    name VARCHAR(255),
    price DECIMAL(10,2),
    program_type VARCHAR(50),
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Modules (
    id SERIAL [pk],
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    deleted_at TIMESTAMP
);



CREATE TABLE Courses (
    id SERIAL [pk],
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Lessons (
    id SERIAL [pk],
    course_id INT [ref: > Courses.id],
    title VARCHAR(255),
    content TEXT,
    video_url VARCHAR(255),
    position INT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP 
);

CREATE TABLE ProgramModules (
    program_id INT [ref: > Programs.id],
    module_id INT [ref: > Modules.id],
    (program_id, module_id) [pk]
);

CREATE TABLE CourseModules (
    course_id INT [ref: > Courses.id],
    module_id INT [ref: > Modules.id],
    (course_id, module_id) [pk]
);


CREATE TABLE Users (
    id SERIAL [pk],
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255),
    role user_role,
    teaching_group_id INT [ref: > TeachingGroups.id],
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    deleted_at TIMESTAMP,
);


CREATE TABLE TeachingGroups (
    id SERIAL [pk],
    slug VARCHAR(255),
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Enrollments (
    id SERIAL [pk],
    user_id INT [ref: > Users.id],
    program_id INT [ref: > Programs.id],
    status subscription_status,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Payments (
    id SERIAL [pk],
    enrollment_id INT [ref: < Enrollment.id],
    payment_amount INT,
    status payment_state,
    date_of_payment TIMESTAMP,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE ProgramCompetions (
    id SERIAL [pk],
    user_id INT [ref: > Users.id],
    program_id INT [ref: > Programs.id],
    status program_completion_status NOT NULL,
    start_program_completion TIMESTAMP,
    finish_program_completion TIMESTAMP,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Certificates (
    id SERIAL [pk],
    user_id INT [ref: > Users.id],
    program_id INT [ref: > Programs.id],
    certificate_url VARCHAR(255),
    date_of_issue  TIMESTAMP,
    created_at TIMESTAMP WITH [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP WITH [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Quizzes (
    id SERIAL [pk],
    lesson_id INT [ref: > Lessons.id],
    name VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Questions (
    id SERIAL [pk],
    quiz_id INT [ref: > Quizzes.id],
    content TEXT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Answers (
    id SERIAL [pk],
    question_id INT [ref: > Questions.id],
    content TEXT,
    is_correct BOOLEAN
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Exercises (
    id SERIAL [pk],
    lesson_id INT [ref: > Lessons.id],
    name VARCHAR(255),
    exercise_url VARCHAR(255),
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Discussions (
    id SERIAL [pk],
    lesson_id INT [ref: > Lessons.id],
    parent_id INT [ref: > Discussions],
    content TEXT,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

CREATE TABLE Blog (
    id SERIAL [pk],
    student_id INT [ref: > Students.id],
    title VARCHAR(255) UNIQUE,
    content TEXT,
    status article_status,
    created_at TIMESTAMP [default: 'CURRENT_TIMESTAMP'],
    updated_at TIMESTAMP [default: 'CURRENT_TIMESTAMP']
);

