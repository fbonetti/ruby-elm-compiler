require 'spec_helper'

describe Elm::Compiler do
  let(:test_file) { 'spec/fixtures/Test.elm' }

  it 'has a version number' do
    expect(Elm::Compiler::VERSION).not_to be nil
  end

  describe '#compile' do
    it "should raise ExecutableNotFound if Elm isn't installed" do
      allow(Elm::Compiler).to receive(:elm_executable_exists?).and_return(false)
      code = proc { Elm::Compiler.compile(test_file) }
      expect(&code).to raise_exception(Elm::Compiler::ExecutableNotFound)
    end

    context 'output_path NOT given' do
      it 'should return a string if no output_path is given' do
        output = Elm::Compiler.compile(test_file)
        expect(output).to be_instance_of(String)
        expect(output.empty?).to be(false)
      end

      it 'should accept a string or an array of strings' do
        output = Elm::Compiler.compile([test_file])
        expect(output).to be_instance_of(String)
        expect(output.empty?).to be(false)
      end
    end

    context 'output_path given' do
      before do
        File.delete('elm.js') if File.exist?('elm.js')
      end

      after do
        File.delete('elm.js')
      end

      it 'should write to the given output_path' do
        output = Elm::Compiler.compile(test_file, output_path: 'elm.js')
        expect(output).to be_nil
        expect(File.exist?('elm.js')).to be(true)
      end

      it 'should accept a string or an array of strings' do
        output = Elm::Compiler.compile([test_file], output_path: 'elm.js')
        expect(output).to be_nil
        expect(File.exist?('elm.js')).to be(true)
      end
    end

    context 'elm_path given' do
      it 'should raise ExecutableNoFound if path is bad' do
        code = proc { Elm::Compiler.compile(test_file, elm_path: "/dev/null") }
        expect(&code).to raise_exception(Elm::Compiler::ExecutableNotFound)
      end

      it 'should work if path is good' do
        output = Elm::Compiler.compile(test_file, elm_path: 'elm')
        expect(output).to be_instance_of(String)
        expect(output.empty?).to be(false)
      end
    end

    context 'native debugger' do
      it 'output should include native debugger functions if debug set to true' do
        prod = Elm::Compiler.compile(test_file, elm_path: 'elm')
        dev = Elm::Compiler.compile(test_file, elm_path: 'elm', debug: true)
        expect(dev.length).to be > prod.length
      end
    end
  end
end
