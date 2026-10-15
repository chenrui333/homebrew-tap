class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "2fc82c7e44f60ad331b50a153366d8634ed63d982198657e33524b76c0513557"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "393ad58b595b3ed5a305f51520d8fcb35093b4b4c242d2fbf73e9ba451305681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef56605d9fe53939579a6130ff782fc8d7fcf9ef60b3b62ad5bb14d53cebfe8e"
    sha256 cellar: :any,                 arm64_linux:   "69902e5e14b7c27bbd052731ffabdd2780d3ab64b0ac7b4135ad1186867711b8"
    sha256 cellar: :any,                 x86_64_linux:  "a4e329bae247a23389f766372915a477dbb8b317b2ab3442458315d1ac320b77"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
