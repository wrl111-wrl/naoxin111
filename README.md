# Student Leave Management System

# Project Introduction
The Student Leave Management System is a digital management tool designed specifically for schools and training institutions to streamline the leave application and approval process, improve management efficiency, and achieve standardized and information-based management of leave records. The system supports functions such as students submitting leave applications online, teachers/administrators approving applications, and statistical analysis of leave data, making it suitable for daily leave management scenarios in various educational institutions.

# Features
1. Multi-role Management
Students: Submit leave applications, check application status, modify/withdraw unapproved applications
Teachers/Counselors: Approve students' leave applications, view leave records of students under their jurisdiction
Administrators: System configuration, user management, permission assignment, full data statistics
2. Leave Process Management
Supports multiple leave types (sick leave, personal leave, official leave, etc.)
Custom approval processes (single-level approval/multi-level approval)
Automatic calculation of leave duration (including exclusion of holidays/weekends)
Real-time update of application status (pending approval, approved, rejected)
3. Data Statistics and Query
Statistical leave data by class, grade, and time period
Export leave records (Excel/CSV format)
Query and summary of students' leave history
4. System Security and Convenience
Role-based access control (RBAC)
Operation log recording to ensure process traceability
Responsive design, supporting computer access

# Technical Architecture
Frontend: Vue.js
Backend: Spring Boot
Database: SQL Server
Deployment Environment: Docker containerized deployment
Development Language: Java
  
# Installation and Deployment
1. Prerequisites
Operating System: Windows / Linux / macOS
Database: Microsoft SQL Server Management Studio 18
JDK 11+
Maven 3.6+
2. Deployment Steps
1) Clone the code repository
git clone https://github.com/your-org/student-leave-management.git
cd student-leave-management
2) Configure the database
Create database: CREATE DATABASE leave_management DEFAULT CHARACTER SET utf8mb4;
Modify the configuration file (application.yml or .env) and fill in the database connection information
3) Initialize data
Execute the database script: sql/init.sql (create table structure and initial data)
4) Build and start
Backend (Spring Boot):
mvn clean package -Dmaven.test.skip=true
java -jar target/leave-management-1.0.0.jar
Frontend:
cd frontend
npm install
npm run build  # Build production environment package
# Deploy to Nginx or directly start the development environment
npm run dev
5) Access the system
Default address: http://localhost:8080 (backend) / http://localhost:80 (frontend, need to configure Nginx proxy)
Initial account: Administrator admin/admin, student xuehao/123456,teacher gonghao/123456

# User Guide

1. Student Operation
After logging in to the system, click "Leave Application" to enter the form page
Select the leave type, fill in the leave time, reason and other information
After submitting the application, you can check the approval progress in "My Leaves"
Unapproved applications can be clicked "Modify" or "Withdraw"
2. Teacher Operation
After logging in to the system, view the applications submitted by students in the "Pending Approval List"
Click on the application to view details, select "Approve" or "Reject" and fill in comments
View historical approval records in the "Approved List"
3. Administrator Operation
Enter "System Management" to configure leave types, approval processes, etc.
Add/edit student and teacher accounts and permissions in "User Management"
View the school's leave data reports through "Data Statistics"

# Frequently Asked Questions

What if I forget my password?
Contact the administrator to reset the password. The administrator can modify the account password in "User Management".
How to modify the approval process?
Administrators can enter "System Configuration - Approval Process" to add/delete approval nodes and set approval roles.
Can leave records be exported in batches?
Yes, after filtering conditions on the "Data Query" page, click the "Export" button to generate an Excel file.
Does the system support multi-campus management?
Yes, administrators can add campus information in "Campus Management", and user accounts can be associated with the corresponding campus.

# Version Update Log

v1.0.0 (2025-10-21)
Initial version, including basic functions of leave application, approval, and data statistics

# Contact Information

Project Maintenance: 17816306303@163.com
Feedback: 17816306303@163.com
Technical Support: 17816306303@163.com

# Open Source License

This project adopts the MIT License, allowing free use, modification and distribution.
