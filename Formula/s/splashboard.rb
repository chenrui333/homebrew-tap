class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b124af6a450383ebce85563a19e43d712d59e72f58cff2fd703e81d94c2ea339"
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
