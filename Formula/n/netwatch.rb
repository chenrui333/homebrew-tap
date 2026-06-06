class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "510e81f0a4ace0152ef59b276d1dadddde19b810143d341d286570dfa1fa5cf2"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9556f94d7fb1dc0a063bd14ae3228835e91c8fa17cb3c7ef0fc1c6c30e87bf67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4496d770c5d80ccadda0bbcc5c3bdcae24748ece774cdd8eefe1497751df7147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21be8d20310e8bca82a8ecae05e7308d36213a3860c5826f4b9e185b8725419"
    sha256 cellar: :any,                 arm64_linux:   "ecce4c8518d04680de7f7efb6b49db3e98487f61269ba52acaaa3c20df35eccb"
    sha256 cellar: :any,                 x86_64_linux:  "7442eb91f0c2713b05fd2560aed7c5d669a36c13e82377d1a303819d209b53c6"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
