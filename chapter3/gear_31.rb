# 3.1
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end

  def ratio
    chainring / cog.to_f
  end
# ...
end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim       = rim
    @tire      = tire
  end

  def diameter
    rim + (tire * 2)
  end
# ...
end

Gear.new(52, 11, 26, 1.5).gear_inches


# 依存オブジェクトの注入
# 3.2-1
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end
# ...
end

Gear.new(52, 11, 26, 1.5).gear_inches

# 3.2-2
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog       = cog
    @wheel     = wheel
  end

  def gear_inches
     ratio * wheel.diameter
  end
# ...
end

# Gear は‘diameter’を知る‘Duck’を要求する。
Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches


# インスタンス変数の作成を分離する
# 3.2-3
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @wheel     = Wheel.new(rim, tire)
  end

  def gear_inches
    ratio * wheel.diameter
  end
# ...
end

# 3.2-4
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog       = cog
    @rim       = rim
    @tire      = tire
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def wheel
    @wheel ||= Wheel.new(rim, tire)
  end
  # ...
end

# 脆い外部メッセージを隔離する-1
def gear_inches
  ratio * wheel.diameter
end

def gear_inches
  #... 恐ろしい計算が何行かある
  foo = some_intermediate_result * wheel.diameter
  #... 恐ろしい計算がさらに何行かある
end

# 脆い外部メッセージを隔離する-2
def gear_inches
  #... 恐ろしい計算が何行かある
  foo = some_intermediate_result * diameter
  #... 恐ろしい計算がさらに何行かある
end

def diameter
  wheel.diameter
end

# 引数の順番への依存を取り除く
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog       = cog
    @wheel     = wheel
  end
  ...
end

Gear.new(
  52,
  11,
  Wheel.new(26, 1.5)).gear_inches

# 初期化の際の引数にハッシュを使う
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(args)
    @chainring = args[:chainring]
    @cog       = args[:cog]
    @wheel     = args[:wheel]
  end
  ...
end

Gear.new(
  :chainring => 52,
  :cog       => 11,
  :wheel     => Wheel.new(26, 1.5)).gear_inches

# 明示的にデフォルト値を設定する-1
# || を使って、デフォルト値を指定している
def initialize(args)
  @chainring = args[:chainring] || 40
  @cog       = args[:cog]       || 18
  @wheel     = args[:wheel]
end

# 明示的にデフォルト値を設定する-2
# fetchを使ってデフォルト値を指定している
def initialize(args)
  @chainring = args.fetch(:chainring, 40)
  @cog       = args.fetch(:cog, 18)
  @wheel     = args[:wheel]
end

# 明示的にデフォルト値を設定する-3
# デフォルト値のハッシュをマージすることでデフォルト値を指定している
def initialize(args)
  args = defaults.merge(args)
  @chainring = args[:chainring]
#   ...
end

def defaults
  {:chainring => 40, :cog => 18}
end

# 複数のパラメーターを用いた初期化を隔離する
# Gearが外部インターフェースの一部の場合
module SomeFramework
  class Gear
    attr_reader :chainring, :cog, :wheel
    def initialize(chainring, cog, wheel)
      @chainring = chainring
      @cog       = cog
      @wheel     = wheel
    end
  # ...
  end
end

# 外部のインターフェースをラップし、自身を変更から守る
module GearWrapper
  def self.gear(args)
    SomeFramework::Gear.new(args[:chainring],
                            args[:cog],
                            args[:wheel])
  end
end

# 引数を持つハッシュを渡すことでGearのインスタンスを作成できるようになった
GearWrapper.gear(
  :chainring => 52,
  :cog       => 11,
  :wheel     => Wheel.new(26, 1.5)).gear_inches
