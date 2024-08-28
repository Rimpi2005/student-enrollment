// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentEnrollment {
    // Struct to represent a course
    struct Course {
        string name;
        bool exists;
    }

    // Struct to represent a student
    struct Student {
        string name;
        mapping(string => bool) enrolledCourses; // mapping to track enrolled courses
    }

    // Mapping of student addresses to Student structs
    mapping(address => Student) private students;
    // Mapping of course names to Course structs
    mapping(string => Course) private courses;
    // Array to keep track of course names
    string[] private courseList;

    // Event to be emitted when a course is added
    event CourseAdded(string courseName);
    // Event to be emitted when a student is enrolled in a course
    event Enrolled(address student, string courseName);

    // Modifier to check if a course exists
    modifier courseExists(string memory courseName) {
        require(courses[courseName].exists, "Course does not exist.");
        _;
    }

    // Function to add a new course
    function addCourse(string memory courseName) public {
        require(!courses[courseName].exists, "Course already exists.");
        courses[courseName] = Course(courseName, true);
        courseList.push(courseName);
        emit CourseAdded(courseName);
    }

    // Function to enroll a student in a course
    function enrollInCourse(string memory courseName) public courseExists(courseName) {
        students[msg.sender].enrolledCourses[courseName] = true;
        emit Enrolled(msg.sender, courseName);
    }

    // Function to check if a student is enrolled in a course
    function isEnrolledInCourse(address studentAddress, string memory courseName) public view returns (bool) {
        return students[studentAddress].enrolledCourses[courseName];
    }

    // Function to get the list of courses
    function getCourses() public view returns (string[] memory) {
        return courseList;
    }
}
