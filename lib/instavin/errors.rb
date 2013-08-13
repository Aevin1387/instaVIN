module InstaVIN
  class InstaVINError < StandardError; end
  class DeveloperError < InstaVINError; end
  class DowntimeError < InstaVINError; end
  class NoDataError < InstaVINError; end
end
