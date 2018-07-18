struct School
  getter name, profiles

  @name : String
  @profiles : Hash(Array(Symbol) => Int32)
  # @profiles : Array({ext: Array(Symbol), size: Int32, co_sub: Array(Symbol)}) # co_sub => counted subjects
  # [{ext: [:biologia, :chemia, :fizyka], size: 15, co_sub: [:matematyka, :polski, :biologia, :chemia]}]

  def initialize(@name, @profiles); end
end

struct Student
  @name : String
  @points_from_exams : Int32
  @marks : Hash(Symbol => Int32)

  def initialize(@name, @points_from_exams, @marks); end
end

# Avalaible subjects
# matematyka
# polski
# angielski
# historia
# wos
# biologia
# chemia
# fizyka
# geografia
# informatyka
# 
# School.new("Sieniu", [
#   {
#     ext: [:biologia, :chemia, :fizyka],
#     size: 15,
#     co_sub: [:polski, :matematyka, :chemia, :fizyka]
#   },
#   {
#     
#   }
#   ])

# 1100 avalaible

schools = [
  School.new("Sieniu", [
      [:matematyka, :historia, :angielski] => 30,
      [:polski, :historia, :wos] => 30,
      [:matematyka, :fizyka, :informatyka, :angielski] => 30,
      [:biologia, :chemia, :fizyka] => 15,
      [:biologia, :chemia, :angielski] => 15,
      [:biologia, :chemia, :polski] => 30,
      [:matematyka, :fizyka, :informatyka] => 30,
      [:biologia, :chemia, :matematyka] => 30,
      [:matematyka, :geografia, :angielski] => 30,
    ]),
  School.new("Traugutt", [
      [:polski, :historia, :wos] => 30,
      [:biologia, :chemia, :matematyka] => 30,
      [:biologia, :chemia, :angielski] => 30,
      [:geografia, :angielski, :matematyka] => 30,
      [:matematyka, :fizyka, :informatyka] => 15,
      [:matematyka, :fizyka] => 15,
      [:international_mature] => 30,
    ]),
  School.new("Kopernik", [
      [:biologia, :chemia, :angielski] => 30,
      [:polski, :angielski, :historia] => 30,
      [:polski, :angielski, :wos] => 30,
      [:matematyka, :fizyka, :informatyka] => 30,
      [:polski, :geografia :wos] => 30,
      [:matematyka, :geografia :wos] => 30,
      [:matematyka, :angielski, :geografia =>] 30,
    ]),
  School.new("Słowacki", [
      [:polski, :historia, :wos] => 30,
      [:polski, :angielski, :historia] => 30,
      [:geografia, :angielski, :niemiecki] => 15,
      [:geografia, :angielski, :włoski] => 15,
      [:polski, :geografia, :wos] => 30,
      [:biologia, :chemia, :angielski] => 30,
      [:biologia, :chemia, :matematyka] => 30,
    ]),
  School.new("Biegański", [
      [:matematyka, :informatyka, :angielski] => 30,
      [:angielski, :matematyka, :geografia] => 30,
      [:polski, :historia, :wos] => 30,
      [:polski, :angielski, :geografia] => 30,
      [:angielski, :biologia, :chemia] => 30,
      [:angielski, :biologia, :chemia] => 30,
    ])
]

students = [] of Student