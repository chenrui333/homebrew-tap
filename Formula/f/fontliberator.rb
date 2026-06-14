class Fontliberator < Formula
  # TODO: upstream has no tags; using HEAD commit as fake 0.1.0 release
  desc "Fully automatic font clean-room reimplementor"
  homepage "https://github.com/robinpie/fontliberator"
  url "https://github.com/robinpie/fontliberator/archive/47541ea54b35d952956ee8ce85a4ca0909ec4a69.tar.gz"
  version "0.1.0"
  sha256 "4f652706720ce0fe3b9ccb0238b050e5a9392468f886d4ca563593ec112630bb"
  license "GPL-2.0-only"
  head "https://github.com/robinpie/fontliberator.git", branch: "main"

  uses_from_macos "perl"

  def install
    bin.install "fontliberator.pl" => "fontliberator"
  end

  test do
    output = shell_output("#{bin}/fontliberator 2>&1", 1)
    assert_match "--font, --family and --output are all required", output
    assert_match "black-box font tracer", output
  end
end
