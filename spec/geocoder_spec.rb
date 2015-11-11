require 'spec_helper'

describe InOrOut::Geocode do

  describe 'build_address_string_for' do
    let(:data) { { "street"=>"via Sommarive", "number"=>"18", "zip"=>"38123", "city"=>"Trento", "state"=>"TN" } }

    describe "when a valid template is provided" do
      let(:template) { "%{street} %{number}, %{zip} %{city} (%{state})" }

      it "returns a valid address string" do
        expect(InOrOut::Geocode.send(:build_address_string_for, data, template)).to eq("via Sommarive 18, 38123 Trento (TN)")
      end
    end
  end

  describe 'geocode' do
    before do
      allow(data).to receive(:headers).and_return(["street","number","zip","city","state"])
    end

    describe "when an invalid template is provided" do
      let(:data) { [{ "street"=>"via Sommarive", "number"=>"18", "zip"=>"38123", "city"=>"Trento", "state"=>"TN" }] }
      let(:template) { "%{flipsod}" }

      it "throws an exception" do
        expect{ InOrOut::Geocode.geocode data, template }.to raise_error(InOrOut::AddressTemplateError, "Some keys in the address template do not match any column")
      end
    end

    describe "when a valid template is provided" do
      let(:template) { "%{street} %{number}, %{zip} %{city} (%{state})" }

      describe "when records can be geocoded" do
        let(:data) { [{ "street"=>"via Sommarive", "number"=>"18", "zip"=>"38123", "city"=>"Trento", "state"=>"TN" }] }

        it "returns the record with added latitude and longitude" do
          expect(InOrOut::Geocode.geocode(data, template).first).to include("latitude" => 46.0659552, "longitude" => 11.1500445)
        end
      end

      describe "when records cannot be geocoded" do
        let(:data) { [{ "street"=>"zapfgharma", "number"=>"-99", "zip"=>"0678", "city"=>"Zmorrgamand", "state"=>"ZZ" }] }

        it "returns the record with empty latitude and longitude" do
          expect(InOrOut::Geocode.geocode(data, template).first).to include("latitude" => nil, "longitude" => nil)
        end
      end

    end
  end
end
