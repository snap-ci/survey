require_relative '../env'
require 'tmpdir'
require 'json'

describe Processor do
  it 'outputs active surveys' do
    inputdir = Dir.mktmpdir
    outputdir = Dir.mktmpdir

    File.open(File.join(inputdir, 'favorite_language.json'), 'w') do |f|
      f.write({
        active: true,
        question: 'Whats your favorite language?',
        answers: ['Kobol', 'Java', 'Visual Basic']
      }.to_json)
    end

    File.open(File.join(inputdir, 'is_tdd_dead.json'), 'w') do |f|
      f.write({
        question: 'Do you think TDD is dead?',
        answers: ['Yes', 'No', 'Who cares!', 'TDD what?']
      }.to_json)
    end

    Processor.new.run(inputdir, outputdir)

    surveys_data = {
      surveys: [
        {
          id: 'favorite_language',
          question: 'Whats your favorite language?',
          answers: ['Kobol', 'Java', 'Visual Basic']
        }
      ]
    }

    JSON.parse(File.read(File.join(outputdir, 'surveys.json')), symbolize_names: true).should == surveys_data
  end

  it 'renders empty file when no changelogs are present' do
    inputdir = Dir.mktmpdir
    outputdir = Dir.mktmpdir

    Processor.new.run(inputdir, outputdir)

    surveys_data = { surveys: [] }

    JSON.parse(File.read(File.join(outputdir, 'surveys.json')), symbolize_names: true).should == surveys_data
  end
end
