# Student Leave Management System

## Project Overview
The Student Leave Management System is a digital management tool designed specifically for schools and training institutions to streamline the leave application and approval process, enhance management efficiency, and achieve standardized, information-based management of leave records. The system supports online submission of leave applications by students, approval by teachers/administrators, and statistical analysis of leave data, making it suitable for daily leave management scenarios in various educational institutions.

## Features

### 1. Multi-Role Management
- **Student**: Submit leave applications, view application status, modify/revoke unapproved applications
- **Teacher/Counselor**: Approve student leave applications, view leave records of students under their jurisdiction
- **Administrator**: System configuration, user management, permission assignment, comprehensive data statistics

### 2. Leave Process Management
- Supports multiple leave types (sick leave, personal leave, official leave, etc.)
- Customizable approval processes (single-level/multi-level approval)
- Automatic calculation of leave duration (excluding holidays/weekends)
- Real-time updates of application status (Pending, Approved, Rejected)

### 3. Data Statistics and Query
- Statistical analysis of leave data by class, grade, and time period
- Export leave records (Excel/CSV format)
- Query and summary of student leave history

### 4. System Security and Convenience
- Role-Based Access Control (RBAC)
- Operation log recording to ensure process traceability
- Responsive design, supports computer access

## Technical Architecture
- **Frontend**: Vue.js
- **Backend**: Spring Boot
- **Database**: SQL Server
- **Deployment Environment**: Docker containerized deployment
- **Development Language**: Java

## Installation and Deployment

### Prerequisites
- **Operating System**: Windows / Linux / macOS
- **Database**: Microsoft SQL Server Management Studio 18
- **JDK 11+**
- **Maven 3.6+**

### Deployment Steps

1. **Clone the code repository**
   ```bash
   git clone https://github.com/your-org/student-leave-management.git
   cd student-leave-management
   ```

2. **Configure the database**
   - Create the database: `CREATE DATABASE leave_management DEFAULT CHARACTER SET utf8mb4;`
   - Modify the configuration file (`application.yml` or `.env`), fill in the database connection information

3. **Initialize data**
   - Execute the database script: `sql/init.sql` (creates table structures and initial data)

4. **Build and start**
   - **Backend (Spring Boot)**:
     ```bash
     mvn clean package -Dmaven.test.skip=true
     java -jar target/leave-management-1.0.0.jar
     ```
   - **Frontend**:
     ```bash
     cd frontend
     npm install
     npm run build  # Build production package
     # Deploy to Nginx or start the development environment directly
     npm run dev
     ```

5. **Access the system**
   - Default addresses: http://localhost:8080 (Backend) / http://localhost:80 (Frontend, requires Nginx proxy configuration)
   - Initial accounts: Administrator `admin/admin123`, Student `student1/123456`

## User Guide

### Student Operations
- After logging in, click "Leave Application" to enter the form page
- Select the leave type, fill in the leave time, reason, and other information
- After submission, check the approval progress in "My Leave"
- Unapproved applications can be modified or revoked by clicking "Modify" or "Revoke"

### Teacher Operations
- After logging in, view student-submitted applications in the "Pending Approval List"
- Click on an application to view details, choose "Approve" or "Reject", and fill in comments
- View historical approval records in the "Approved List"

### Administrator Operations
- Enter "System Management" to configure leave types, approval processes, etc.
- Add/edit student and teacher accounts and permissions in "User Management"
- View school-wide leave data reports through "Data Statistics"

## Frequently Asked Questions (FAQ)

**Q: Forgot password?**  
A: Contact the administrator to reset it. The administrator can modify account passwords in "User Management".

**Q: How to modify the approval process?**  
A: The administrator can go to "System Configuration - Approval Process" to add/delete approval nodes and set approval roles.

**Q: Can leave records be exported in bulk?**  
A: Yes, after setting filters on the "Data Query" page, click the "Export" button to generate an Excel file.

**Q: Does the system support multi-campus management?**  
A: Yes. The administrator can add campus information in "Campus Management", and user accounts can be associated with the corresponding campus.

## Version Update Log

### v1.0.0 (2025-10-21)
- Initial version, includes basic functions for leave application, approval, and data statistics

## Contact Information
- **Project Maintenance**: zhezhishizhanwei@aaa.com
- **Issue Feedback**: zheyeshizhanwei@aaa.com
- **Technical Support**: zhehaishizhanwei@aaa.com

## Open Source License
This project is licensed under the MIT License, allowing free use, modification, and distribution.
