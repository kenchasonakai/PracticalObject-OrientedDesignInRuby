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
