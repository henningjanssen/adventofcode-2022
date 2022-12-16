#!/usr/bin/env ruby

class OperationValue
    def initialize(val)
        @val = (val == "old" ? nil : val.to_i)
    end

    def get(item)
        return @val == nil ? item : @val
    end
end

class Operation
    def initialize(lhs, operator, rhs)
        @lhs = OperationValue.new(lhs)
        @operator = operator
        @rhs = OperationValue.new(rhs)
    end

    def operate(oldval)
        lhs = @lhs.get(oldval)
        rhs = @rhs.get(oldval)
        return case @operator
            when "+"
                lhs + rhs
            when "-"
                lhs - rhs
            when "*"
                lhs * rhs
            when "/"
                lhs / rhs
            when "%"
                lhs % rhs
            when "to_i"
                lhs.to_i
            else
                lhs
            end
    end
end

class Throw
    attr_reader :item, :target
    def initialize(item, target)
        @item = item
        @target = target
    end
end

class ThrowDecider
    attr_reader :modulo_rhs

    def initialize(modulo_rhs, true_target, false_target)
        @modulo_rhs = modulo_rhs
        @true_target = true_target
        @false_target = false_target
    end

    def decide(item)
        return Throw.new(
            item,
            item % @modulo_rhs == 0 ? @true_target : @false_target
        )
    end
end

class ThrowDeciderBuilder
    attr_writer :modulo_rhs
    attr_writer :true_target
    attr_writer :false_target

    def build()
        return ThrowDecider.new(@modulo_rhs, @true_target, @false_target)
    end
end

class Monkey
    attr_reader :inspect_count

    def initialize(operation, throw_decider, initial_inventory = [])
        @operation = operation
        @throw_decider = throw_decider
        @inventory = initial_inventory
        @inspect_count = 0
    end

    def getTestRing()
        return @throw_decider.modulo_rhs
    end

    def give_item(item)
        @inventory.append(item)
    end

    def play(calming_operation, monkeys)
        throws = []
        while item = @inventory.shift
            item = @operation.operate(item)
            item = calming_operation.operate(item).to_i
            throws.append(@throw_decider.decide(item))
            @inspect_count += 1
        end
        return throws
    end
end

class MonkeyBreeder
    attr_writer :operation
    attr_reader :throw_decider_builder
    attr_writer :inventory

    def initialize()
        @throw_decider_builder = ThrowDeciderBuilder.new
    end

    def breed()
        return Monkey.new(@operation, @throw_decider_builder.build, @inventory)
    end
end

class Parser
    def self.parse(filename)
        monkeys = []
        current_breeder = nil
        File.readlines(filename, chomp: true).each do |line|
            if line.empty?
                monkeys.append(current_breeder.breed())
                current_breeder = nil
                next
            end
            if line.start_with?("Monkey")
                current_breeder = MonkeyBreeder.new
                next
            end
            line = line.strip
            if line.start_with?("Starting items:")
                offset = "Starting items: ".length
                current_breeder.inventory = line[offset, line.length-offset].split(", ").map{|n| n.to_i}
                next
            elsif line.start_with?("Operation:")
                parts = line.split
                current_breeder.operation = Operation.new(parts.at(-3), parts.at(-2), parts.last)
                next
            elsif line.start_with?("Test:")
                current_breeder.throw_decider_builder.modulo_rhs = line.split.last.to_i
                next
            elsif line.start_with?("If true:")
                current_breeder.throw_decider_builder.true_target = line.split.last.to_i
                next
            elsif line.start_with?("If false:")
                current_breeder.throw_decider_builder.false_target = line.split.last.to_i
                next
            end
        end
        if current_breeder != nil
            monkeys.append(current_breeder.breed)
        end
        return monkeys
    end
end

class Game
    def initialize(monkeys, calming_operation)
        @monkeys = monkeys
        @calming_operation = calming_operation
        @ring = 1
        for m in @monkeys
            @ring *= m.getTestRing
        end
    end

    def play(rounds)
        rounds.times do
            self.play_round()
        end
    end

    def play_round()
        for monkey in @monkeys
            throws = monkey.play(@calming_operation, @monkeys)
            for t in throws
                @monkeys.at(t.target).give_item(t.item % @ring)
            end
        end
    end

    def get_monkey_business_level()
        return @monkeys.map{|m| m.inspect_count}.sort.max(2).reduce(1, :*)
    end
end

if __FILE__ == $0
    filename = "input.txt"
    
    game1 = Game.new(Parser.parse(filename), Operation.new("old", "/", 3))
    game1.play(20)
    puts "part1: ", game1.get_monkey_business_level

    game2 = Game.new(Parser.parse(filename), Operation.new("old", "noop", 0))
    game2.play(10000)
    puts "part2: ", game2.get_monkey_business_level
end
