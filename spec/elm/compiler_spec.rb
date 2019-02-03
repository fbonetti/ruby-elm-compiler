require 'spec_helper'

describe Elm::Compiler do
  let(:test_file) { 'spec/fixtures/Test.elm' }
  let(:elm_path) { `which elm`.strip }

  it 'has a version number' do
    expect(Elm::Compiler::VERSION).not_to be nil
  end

  describe '#compile' do
    it "should raise ExecutableNotFound if Elm isn't installed" do
      allow(Elm::Compiler).to receive(:elm_executable_exists?).and_return(false)
      code = proc { Elm::Compiler.compile(test_file) }
      expect(&code).to raise_exception(Elm::Compiler::ExecutableNotFound)
    end

    context 'when output_path is not given' do
      context 'when the filename is a string' do
        it 'should return a string' do
          output = Elm::Compiler.compile(test_file)
          expect(output).to be_instance_of(String)
          expect(output.empty?).to be(false)
        end
      end

      context 'when the filename is an array of strings' do
        it 'should return a string' do
          output = Elm::Compiler.compile([test_file])
          expect(output).to be_instance_of(String)
          expect(output.empty?).to be(false)
        end
      end
    end

    context 'when the output_path given' do
      let(:output_path) { 'elm.js' }

      before do
        File.delete(output_path) if File.exist?(output_path)
      end

      after do
        File.delete(output_path)
      end

      context 'when the filename is a string' do
        it 'should write to the given output_path' do
          output = Elm::Compiler.compile(test_file, output_path: output_path)
          expect(output).to be_nil
          expect(File.exist?(output_path)).to be(true)
        end
      end

      context 'when the filename is an array of strings' do
        it 'should write to the given output_path' do
          output = Elm::Compiler.compile([test_file], output_path: output_path)
          expect(output).to be_nil
          expect(File.exist?(output_path)).to be(true)
        end
      end
    end

    context 'when the elm_path given' do
      context 'when the executable is not found' do
        it 'should raise ExecutableNoFound' do
          code = proc { Elm::Compiler.compile(test_file, elm_path: '/dev/nil') }
          expect(&code).to raise_exception(Elm::Compiler::ExecutableNotFound)
        end
      end

      context 'when the executable is found' do
        it 'should work' do
          output = Elm::Compiler.compile(test_file, elm_path: elm_path)
          expect(output).to be_instance_of(String)
          expect(output.empty?).to be(false)
        end
      end
    end

    context 'native debugger' do
      let(:prod) { Elm::Compiler.compile(test_file, elm_path: elm_path) }

      context 'when debug is set to true' do
        it 'should include the debug flag' do
          dev = Elm::Compiler.compile(test_file, elm_path: elm_path, debug: true)
          expect(dev.length).to be > prod.length
        end
      end

      context 'when debug is set to false' do
        it 'should not include the debug flag' do
          dev = Elm::Compiler.compile(test_file, elm_path: elm_path, debug: false)
          expect(dev.length).to eq prod.length
        end
      end
    end
  end
end
