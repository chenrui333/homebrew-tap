class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "510e81f0a4ace0152ef59b276d1dadddde19b810143d341d286570dfa1fa5cf2"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0e12f957226aa52cdb8729ae8725b670a1bea24985fe218a1cbe628eb4c5ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92dafa7817ae9c03806cdfd5d6a264687173b789eae9cf134468644812b4fafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef0040072da513dc0f92767259a6d73f03c20da1234ad24b046e7ea79f25cdd"
    sha256 cellar: :any,                 arm64_linux:   "1796de5cb7670a27dcb713e0c3d1be4e42590be030d54b953b5bc469ae3a9b27"
    sha256 cellar: :any,                 x86_64_linux:  "8681501b0ef806501527cf3a702d0cc2d99b87c19b513aaff32cf7a7a39fb6e8"
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
