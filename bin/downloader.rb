#!/usr/bin/env ruby

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  puts "Error loading dependencies"
  exit
end

require 'commander/import'
require_relative '../lib/hellosign_downloader'

program :version, '0.0.1'
program :description, 'With the following commands you will be able to download documents from HelloSign.'

command :documents do |c|
  c.syntax = 'hs_download documents Document(s)_ID [options]'
  c.summary = 'Download one or several documents from HelloSign using their document ids.'
  c.description = c.summary
  c.example 'Download only one document in PDF format"', 'hs_download documents ce4cd007ce4d9c9bfaa22e12d123d12aa7b23456 -f pdf'
  c.example 'Download several documents given their ids',
            'hs_download documents ce4cd007ce4d9c9bfaa22e12d123d12aa7b23456 b795780709f9b974570309464e06607253c407c4 --format zip'
  c.option '-f', '--format FORMAT', String, 'Specify the download format (PDF or ZIP). Default: PDF' # Option aliasing
  c.option '-o', '--output OUTPUT_PATH', String, 'Specify path to download the documents. Default: Current Path'
  c.action do |args, options|
    HelloSignDownloader::Downloader.new(format: options.format,
                                        output_dir: options.output)
                                    .document_download(args)
  end
end

command :download_from_query do |c|
  c.syntax = 'hs_download download_from_query query_string [options]'
  c.summary = 'Download one or several documents from HelloSign using a query string. More info about available query options at: https://app.hellosign.com/api/reference#Search'
  c.description = c.summary
  c.example 'Download completed documents"', 'hs_download query complete:true'
  c.option '-f', '--format FORMAT', String, 'Specify the download format (PDF or ZIP). Default: PDF' # Option aliasing
  c.option '-o', '--output OUTPUT_PATH', String, 'Specify path to download the documents. Default: Current Path'
  c.action do |args, options|
    HelloSignDownloader::Downloader.new(format: options.format,
                                        output_dir: options.output)
                                   .query_download(args)
  end
end

command :query do |c|
  c.syntax = 'hs_download query query_string [options]'
  c.summary = 'List saved documents using a query string. More info about available query options at: https://app.hellosign.com/api/reference#Search'
  c.description = c.summary
  c.example 'List document(s) completed"', 'hs_download query complete:true'
  c.action do |args, options|
    HelloSignDownloader::Downloader.new.query_documents(args)
  end
end
