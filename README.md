# Description

Write an SQL query that will find all sessions during which the user did homework before the lesson, that is, he performed a sequence of actions:

  * Visited any page 0 or more times;
  * **зашел на rooms.homework-showcase (homework section)**;
  * Visited any page 0 or more times;
  * **зашел на rooms.view.step.content (homework page);**
  * Visited any page 0 or more times;
  * **зашел на rooms.lesson.rev.step.content (lesson page with teacher);**
  * Visited any page 0 or more times;

A session is a user activity in which less than one hour elapses between successive actions. The session starts at the moment of the first of these actions and ends one hour after the last of them.

The result should be an unloading of sessions of the form: <user-id>,<date-time of session start>,<date-time of session end>.

# Links
[Solution](https://github.com/zosimovaa/skyeng---sql/blob/master/skyeng.sql)