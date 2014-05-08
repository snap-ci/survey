require 'json'

class Processor
  def run(inputdir, outputdir)
    active_surveys = Dir[File.join(inputdir, '*.json')].map do |survey_path|
      JSON.parse(File.read(survey_path), symbolize_names: true)
    end.select { |survey| survey[:active] }.map do |survey|
      {
        question: survey[:question],
        answers: survey[:answers]
      }
    end

    File.open(File.join(outputdir, 'surveys.json'), 'w') do |f|
      f.write({ surveys: active_surveys }.to_json)
    end
  end
end
