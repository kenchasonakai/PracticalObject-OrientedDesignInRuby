# ダックを見逃す

class Trip
  attr_reader :bicycles, :customers, :vehicle

  # この 'mechanic' 引数はどんなクラスのものでもよい。
  def prepare(mechanic)
    mechanic.prepare_bicycles(bicycles)
  end

  # ...
end

# *この* クラスのインスタンスを渡すことになったとしても、
# 動作する。
class Mechanic
  def prepare_bicycles(bicycles)
    bicycles.each {|bicycle| prepare_bicycle(bicycle)}
  end

  def prepare_bicycle(bicycle)
    #...
  end
end

# 問題を悪化させる

# 旅行の準備はさらに複雑になった
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      case preparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparer.fill_water_tank(vehicle)
      end
    }
  end
end

# TripCoordinator と Driver を追加した
class TripCoordinator
  def buy_food(customers)
    # ...
  end
end

class Driver
  def gas_up(vehicle)
    #...
  end

  def fill_water_tank(vehicle)
    #...
  end
end

# ダックを見つける
# 旅行の準備はよりかんたんになる
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      preparer.prepare_trip(self)}
  end
end

# すべての準備者（Preparer）は
# 'prepare_trip' に応答するダック
class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each {|bicycle|
      prepare_bicycle(bicycle)}
  end

  # ...
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end

  # ...
end

class Driver
  def prepare_trip(trip)
    vehicle = trip.vehicle
    gas_up(vehicle)
    fill_water_tank(vehicle)
  end
  # ...
end


# クラスで分岐するcase文
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each {|preparer|
      case preparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparer.fill_water_tank(vehicle)
      end
    }
  end
end

# kind_of?とis_a?
if preparer.kind_of?(Mechanic)
  preparer.prepare_bicycles(bicycle)
elsif preparer.kind_of?(TripCoordinator)
  preparer.buy_food(customers)
elsif preparer.kind_of?(Driver)
  preparer.gas_up(vehicle)
  preparer.fill_water_tank(vehicle)
end

# respond_to?
if preparer.responds_to?(:prepare_bicycles)
  preparer.prepare_bicycles(bicycle)
elsif preparer.responds_to?(:buy_food)
  preparer.buy_food(customers)
elsif preparer.responds_to?(:gas_up)
  preparer.gas_up(vehicle)
  preparer.fill_water_tank(vehicle)
end

# 賢くダックを選ぶ
# <tt>find(:first, *args)</tt> を便利に使うためのラッパー。
# このメソッドには <tt>find(:first)</tt> メソッドと
# 同じ引数をすべて渡せる
def first(*args)
  if args.any?
    if args.first.kind_of?(Integer) ||
         (loaded?&& !args.first.kind_of?(Hash))
      to_a.first(*args)
    else
      apply_finder_options(args.first).first
    end
  else
    find_first
  end
end
