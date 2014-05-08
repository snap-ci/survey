require 'json'

class Processor
  def run(inputdir, outputdir)
    active_surveys = Dir[File.join(inputdir, '*.json')].map do |survey_path|
      survey = JSON.parse(File.read(survey_path), symbolize_names: true)
      if survey[:active]
        {
          id: File.basename(survey_path).gsub('.json', ''),
          question: survey[:question],
          answers: survey[:answers]
        }
      else
        nil
      end
    end.compact

    File.open(File.join(outputdir, 'surveys.json'), 'w') do |f|
      f.write({ surveys: active_surveys }.to_json)
    end
  end
end
