class Teacher
  attr_accessor :name, :age, :subject

  def initialize(name:, age:, subject:)
    @name = name
    @age = age
    @subject = subject
  end
end

teacher = Teacher.new(name: 'Alice', age: 30, subject: nil)

p teacher.name.nil?
# => false
p teacher.name.class

p teacher.age.nil?
# => false
p teacher.age.class

p teacher.subject.nil?
# => true
p teacher.subject.class
