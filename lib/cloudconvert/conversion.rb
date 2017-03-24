# frozen_string_literal: true
module Cloudconvert
  # cloudconvert.org API wrapper
  class Conversion
    def initialize(input_format, output_format)
      @input_format = input_format
      @output_format = output_format
    end

    def new_process
      return unless formats_defined?
      new_process_url = '/process'
      payload = {
        apikey: Cloudconvert.configuration.api_key,
        inputformat: @input_format, outputformat: @output_format
      }
      callback_url = Cloudconvert.configuration.callback
      payload[:callback] = callback_url unless callback_url.nil?

      @proc_response ||= client.post(new_process_url, payload)
      @process_url ||= @proc_response['url']
    end

    def conversion_payload(options = {})
      @conv_payload = {
        input: 'download',
        outputformat: @output_format
      }
      @conv_payload.merge!(options)
    end

    def request
      client.post(@process_url, @conv_payload)
    end

    def post_file(file, mime_type)
      Faraday::UploadIO.new(file, mime_type)
    end

    def upload_file
      upload.post(@process_url, @conv_payload)
    end

    def status
      client.get(@process_url)
    end

    def step
      status['step']
    end

    def cancel
      client.get("#{@process_url}/cancel")
    end

    def delete
      client.get("#{@process_url}/delete")
    end

    def list
      client.get("/processes?apikey=#{Cloudconvert.configuration.api_key}")
    end

    def conversion_types(input_format = '', output_format = '')
      uri = '/conversiontypes'

      if !input_format.empty? && !output_format.empty?
        uri += "?inputformat=#{input_format}&outputformat=#{output_format}"
      elsif !input_format.empty?
        uri += "?inputformat=#{input_format}"
      elsif !output_format.empty?
        uri += "?output_format=#{output_format}"
      end

      client.get(uri)
    end

    def current_conversion_types
      client.get("/conversiontypes?inputformat=#{@input_format}&outputformat=#{@output_format}")
    end

    def download_link
      current_status = status
      current_status['output']['url'] if current_status['step'] == 'finished'
    end

    private

    def client
      @client ||= Cloudconvert::Client.new
    end

    def upload
      @upload ||= Cloudconvert::Upload.new
    end

    def formats_defined?
      raise 'Conversion formats not defined!' if @input_format.empty? || @output_format.empty?
      true
    end
  end
end
