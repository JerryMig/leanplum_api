require 'spec_helper'

describe LeanplumApi::DataExportAPI do
  let(:api) { described_class.new }

  around(:all) do |example|
    LeanplumApi.configure { |c| c.developer_mode = false }
    example.run
    LeanplumApi.configure { |c| c.developer_mode = true }
  end

  context 'data export methods' do
    context 'export_data' do
      context 'regular export' do
        it 'should request a data export job with a starttime' do
          VCR.use_cassette('export_data') do
            expect { api.export_data(Time.at(1438660800).utc) }.to raise_error LeanplumApi::BadResponseError
          end
        end

        it 'should request a data export job with start and end dates' do
          VCR.use_cassette('export_data_dates') do
            expect { api.export_data(Date.new(2017, 8, 5), Date.new(2017, 8, 6)) }.to_not raise_error
          end
        end
      end

      context 's3 export' do
        let(:s3_bucket_name) { 'bucket' }
        let(:s3_access_key) { 's3_access_key' }
        let(:s3_access_id) { 's3_access_id' }

        it 'should request an S3 export'
      end
    end

    context 'get_export_results' do
      it 'should get a status for a data export job' do
        VCR.use_cassette('get_export_results') do
          expect(api.get_export_results('export_4727756026281984_2904941266315269120')).to eq({
            files: ['https://leanplum_export.storage.googleapis.com/export-4727756026281984-d5969d55-f242-48a6-85a3-165af08e2306-output-0'],
            number_of_bytes: 36590,
            number_of_sessions: 101,
            state: LeanplumApi::API::EXPORT_FINISHED,
            s3_copy_status: nil
          })
        end
      end
    end
  end
end
