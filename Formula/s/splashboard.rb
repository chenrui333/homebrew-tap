class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "e87940109c0880cba5c248eebf6a0e038b9f72c2ad20acf4bc843c02e29eb14d"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9884580cf658423e55092973087baf5cd315520f0690ff1a9b984fbe8a951889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb8039781d64e7f24e4e9efa197be79005e78831f0504309a306df87e4312dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e66ab39810bdc8633fc01bfb9b47e1a577e2f79cec5d1f176ec705d4f91f9424"
    sha256 cellar: :any,                 arm64_linux:   "5ee2027d6afc71d87d28f5a2f49693185358168b66b889601950f9800ff78e64"
    sha256 cellar: :any,                 x86_64_linux:  "19b2f01ef6ef97690639989b89d9ee2ae2c7cf64fc472161ffcee0157b43dc5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
