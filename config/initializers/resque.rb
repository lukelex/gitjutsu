# frozen_string_literal: true

Resque.logger.formatter = Resque::VerboseFormatter.new
