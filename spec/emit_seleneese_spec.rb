require 'lib/emit_seleneese'

class EmitSeleneeseTest
    describe EmitSeleneese do
        before(:each) do
            @emitter = EmitSeleneese.new('3/2/2010')
        end

        it "should exist" do
            @emitter
        end

        it "should parse a full name into first and last" do
            first, last = @emitter.parse_name('Sean Norton')
            first.should == "Sean"
            last.should == "Norton"
        end

        it "should read names from the input file" do
            @emitter.load_names
            @emitter.name_count.should > 9
        end

        it "should create the first entry" do
            @emitter.load_names
            @emitter.create_first_entry.size.should > 25
        end

    end
end
