class UserCourseShip < ActiveRecord::Base

	#常量
	StatusRefuse = 0
	StatusWaiting = 1
	StatusPassed = 2
	LevelCommon = 0
	LevelWatcher = 1
	LevelAdmin = 2
	LevelCreater = 3

	belongs_to :user
	belongs_to :course
end
