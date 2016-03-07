require 'spec_helper'

describe Elm::Compiler do
  let(:test_file) { 'spec/fixtures/Test.elm' }

  it 'has a version number' do
    expect(Elm::Compiler::VERSION).not_to be nil
  end

  describe '#compile' do
    it "should raise ExecutableNotFound if Elm isn't installed" do
      allow_any_instance_of(Elm::Compiler).to receive(:elm_executable_exists?).and_return(false)
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
        output = Elm::Compiler.compile(test_file, 'elm.js')
        expect(output).to be_nil
        expect(File.exist?('elm.js')).to be(true)
      end

      it 'should accept a string or an array of strings' do
        output = Elm::Compiler.compile([test_file], 'elm.js')
        expect(output).to be_nil
        expect(File.exist?('elm.js')).to be(true)
      end
    end
  end
end
