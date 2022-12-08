// compile with `valac --pkg gio-2.0 solution.vala`
// run with `./solution "input.txt"` or `vala "input.txt" "pt2"`

class Stack : Object {
    protected GenericArray<char> crates = new GenericArray<char>();

    public void moveCratesTo(Stack target, uint count, bool ordered = false) {
        if(ordered) {
            for(uint i = this.crates.length - count; i < this.crates.length; i++) {
                target.push(this.crates[i]);
            }
            this.crates.remove_range(this.crates.length - count, count);
        } else {
            for(uint i = 0; i < count; i++) {
                target.push(this.pop());
            }
        }
    }

    public char pop() {
        char elem = this.top();
        this.crates.remove_index(this.crates.length - 1);
        return elem;
    }

    public void push(char elem) {
        this.crates.add(elem);
    }

    public char top() {
        return this.crates.length > 0 ? this.crates.get(this.crates.length-1) : '-';
    }
}

class Populator {
    public static GenericArray<Stack> parseAndPopulate(DataInputStream stream, bool next_generation = false) {
        string[] stack_lines = {};
        while(true) {
            string line = stream.read_line();
            if(0 == line.length || null == line) {
                break;
            }
            stack_lines += line;
        }

        GenericArray<Stack> stacks = new GenericArray<Stack>();
        string stack_base_line = stack_lines[stack_lines.length - 1];
        string current_stack_num = "";
        for(uint i = 0; i < stack_base_line.length; i++) {
            if(' ' == stack_base_line[i]) {
                if("" != current_stack_num) {
                    stacks.add(new Stack());
                }
                current_stack_num = "";
                continue;
            }
            current_stack_num += @"$(stack_base_line[i])";
        }
        if("" != current_stack_num) {
            stacks.add(new Stack());
        }
        for(int i = stack_lines.length-2; i >= 0; i--) {
            for(int j = 0, k = 0; j < stack_lines[i].length; j += 4, k++) {
                if(stack_lines[i][j] == '[') {
                    stacks.get(k).push(stack_lines[i][j+1]);
                }
            }
        }

        while(true) {
            string line = stream.read_line();
            if(null == line) {
                break;
            }
            if(0 == line.length) {
                continue;
            }
            string[] substrs = line.split(" ");
            int cratect = int.parse(substrs[1]);
            int src = int.parse(substrs[3]);
            int target = int.parse(substrs[5]);
            stacks.get(src-1).moveCratesTo(stacks.get(target-1), cratect, next_generation);
        }
        return stacks;
    }
}

void main(string[] args) {
    var input = File.new_for_path(args[1]);
    if(!input.query_exists()) {
        stderr.printf("File %s does not exist", args[1]);
        return;
    }
    var instream = new DataInputStream(input.read());
    var ng = args.length > 2 && args[2] == "pt2";
    GenericArray<Stack> stacks = Populator.parseAndPopulate(instream, ng);
    stacks.foreach((stack) => {stdout.printf("%c", stack.top());});
    stdout.printf("\n");
}
