# 具象クラスから始める
class Bicycle
  attr_reader :size, :tape_color

  def initialize(args)
    @size       = args[:size]
    @tape_color = args[:tape_color]
  end

  # すべての自転車は、デフォルト値として
  # 同じタイヤサイズとチェーンサイズを持つ
  def spares
    { chain:        '10-speed',
      tire_size:    '23',
      tape_color:   tape_color}
  end

  # ほかにもメソッドがたくさん...
end

bike = Bicycle.new(
        size:       'M',
        tape_color: 'red' )

bike.size     # -> 'M'
bike.spares
# -> {:tire_size   => "23",
#     :chain       => "10-speed",
#     :tape_color  => "red"}

# 複数の型を埋め込む
class Bicycle
  attr_reader :style, :size, :tape_color,
              :front_shock, :rear_shock

  def initialize(args)
    @style        = args[:style]
    @size        = args[:size]
    @tape_color  = args[:tape_color]
    @front_shock = args[:front_shock]
    @rear_shock  = args[:rear_shock]
  end

  # “style”の確認は、危険な道へ進む一歩
  def spares
    if style == :road
      { chain:        '10-speed',
        tire_size:    '23',       # milimeters
        tape_color:   tape_color }
    else
      { chain:        '10-speed',
        tire_size:    '2.1',      # inches
        rear_shock:   rear_shock }
    end
  end
end

bike = Bicycle.new(
        style:        :mountain,
        size:         'S',
        front_shock:  'Manitou',
        rear_shock:   'Fox')

bike.spares
# -> {:tire_size   => "2.1",
#     :chain       => "10-speed",
#     :rear_shock  => 'Fox'}

# 継承を不適切に適応する
class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock  = args[:rear_shock]
    super(args)
  end

  def spares
    super.merge(rear_shock: rear_shock)
  end
end

mountain_bike = MountainBike.new(
                  size:         'S',
                  front_shock:  'Manitou',
                  rear_shock:   'Fox')

mountain_bike.size # -> 'S'

mountain_bike.spares
# -> {:tire_size   => "23",       <- 間違い！
#     :chain       => "10-speed",
#     :tape_color  => nil,        <- 不適切
#     :front_shock => 'Manitou',
#     :rear_shock  => "Fox"}

# 抽象的なスーパークラスを作る
class Bicycle
  # このクラスはもはや空となった。
  # コードはすべて RoadBike に移された。
end

class RoadBike < Bicycle
  # いまは Bicycle のサブクラス。
  # かつての Bicycle クラスからのコードをすべて含む。

  # attr_reader :style, :size, :tape_color,
  #             :front_shock, :rear_shock

  # def initialize(args)
  #   @style        = args[:style]
  #   @size        = args[:size]
  #   @tape_color  = args[:tape_color]
  #   @front_shock = args[:front_shock]
  #   @rear_shock  = args[:rear_shock]
  # end

  # def spares
  #   if style == :road
  #     { chain:        '10-speed',
  #       tire_size:    '23',       # milimeters
  #       tape_color:   tape_color }
  #   else
  #     { chain:        '10-speed',
  #       tire_size:    '2.1',      # inches
  #       rear_shock:   rear_shock }
  #   end
  # end
end

class MountainBike < Bicycle
  # Bicycle のサブクラスのまま（Bicycle は現在空になっている）。
  # コードは何も変更されていない。

  # attr_reader :front_shock, :rear_shock

  # def initialize(args)
  #   @front_shock = args[:front_shock]
  #   @rear_shock  = args[:rear_shock]
  #   super(args)
  # end

  # def spares
  #   super.merge(rear_shock: rear_shock)
  # end
end

road_bike = RoadBike.new(
              size:       'M',
              tape_color: 'red' )

road_bike.size  # => "M"

mountain_bike = MountainBike.new(
                  size:         'S',
                  front_shock:  'Manitou',
                  rear_shock:   'Fox')

mountain_bike.size
# NoMethodError: undefined method 'size'

# 抽象的な振る舞いを昇格する
class Bicycle
  attr_reader :size     # <- RoadBikeから昇格した

  def initialize(args={})
    @size = args[:size] # <- RoadBikeから昇格した
  end
end

class RoadBike < Bicycle
  attr_reader :tape_color

  def initialize(args)
    @tape_color = args[:tape_color]
    super(args)  # <- RoadBikeは'super'を必ず呼ばなければならなくなった
  end
  # ...
end

road_bike = RoadBike.new(
              size:       'M',
              tape_color: 'red' )

road_bike.size  # -> ""M""

mountain_bike = MountainBike.new(
                  size:         'S',
                  front_shock:  'Manitou',
                  rear_shock:   'Fox')

mountain_bike.size # -> 'S'

# 具象から抽象を分ける
class RoadBike < Bicycle
  # ...
  def spares
    { chain:        '10-speed',
      tire_size:    '23',
      tape_color:   tape_color}
  end
end

class MountainBike < Bicycle
  # ...
  def spares
    super.merge({rear_shock:  rear_shock})
  end
end

mountain_bike.spares
# NoMethodError: super: no superclass method 'spares'

class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(args={})
    @size       = args[:size]
    @chain      = args[:chain]
    @tire_size  = args[:tire_size]
  end
  # ...  .
end

# テンプレートメソッドパターンを使う
