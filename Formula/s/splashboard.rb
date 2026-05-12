class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "09c2bc1f3595617abf1188b4fddfbfdd3469e7d95ec58b8fb1758991f15a53b4"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
