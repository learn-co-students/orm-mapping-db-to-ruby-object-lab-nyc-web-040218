class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new()
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
      SQL

      data_records = DB[:conn].execute(sql)

      data_records.map do |data_record|
        self.new_from_db(data_record)
      end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      SQL

      data_records = DB[:conn].execute(sql, name)

      data_records.map do |data_record|
        self.new_from_db(data_record)
      end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
        WHERE grade = 9;
      SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
        WHERE grade < 12;
      SQL

    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(no_of_students)
    sql = <<-SQL
      SELECT * FROM students
        WHERE grade = 10;
      SQL

    DB[:conn].execute(sql)[0..no_of_students - 1]
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
        WHERE grade = 10;
      SQL

    first_student_record = DB[:conn].execute(sql).first
    self.new_from_db(first_student_record)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
        WHERE grade = ?;
      SQL

    DB[:conn].execute(sql, grade)
  end
end
