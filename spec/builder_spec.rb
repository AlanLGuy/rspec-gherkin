require 'spec_helper'

describe RSpecGherkin::Builder do

  context 'a simple feature' do
    let(:feature_file) { File.expand_path('../features/simple_feature.feature', File.dirname(__FILE__)) }
    let(:builder) { RSpecGherkin::Builder.build(feature_file) }
    let(:feature) { builder.features.first }

    it 'parses the feature' do
      expect(feature).to be_a_kind_of(RSpecGherkin::Feature)
      expect(feature.name).to eq('A simple feature')
    end

    it 'gets all the scenarios in the feature' do
      expect(feature.scenarios.count).to eq(4)
      expect(feature.scenarios.first).to be_a_kind_of(RSpecGherkin::Scenario)
      expect(feature.scenarios.first.name).to eq('A simple scenario')
    end

    it 'gets tags associated with the feature' do
      expect(feature.tags).to eq(['@feature_tag'])
    end

    it 'gets tags associated with the scenario' do
      expect(feature.scenarios.first.tags).to eq(['@scenario_tag'])
    end
  end

  context 'with scenario outlines' do
    let(:feature_file) { File.expand_path('../features/scenario_outline.feature', File.dirname(__FILE__)) }
    let(:builder) { RSpecGherkin::Builder.build(feature_file) }
    let(:feature) { builder.features.first }


    it 'extracts scenario' do
      expect(feature.scenarios.map(&:name)).to eq(['a simple outline'])
      expect(feature.scenarios.first.type).to eq(:ScenarioOutline)
    end

    it 'extracts examples from an outline' do
      expect(feature.scenarios.first.examples).to eq(RSpecGherkin::Example)
    end
  end
end
