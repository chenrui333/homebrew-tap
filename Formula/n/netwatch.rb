class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "0a8cccd31d1ffff41f6ab832731e4de02885078d8475750fd1a9baafb894d727"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaef051ebc2d7a5d3ed1c8b874baece9a4b3f2df042accf918a8fcf3a31fc593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aaabb92c34bc5dde1df57fbde2296e42b46b5934ffecc2935e538e1ff5e365d"
    sha256 cellar: :any,                 arm64_linux:   "9081d7418552e1b60b75c09b49076d3b46b0c2385f7c00924dfa38c4b6f0ddea"
    sha256 cellar: :any,                 x86_64_linux:  "7d77857cfc263e611dc990e381eccf774fc516813dec20ae6226630f3bbf856b"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
