class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.4.0.tar.gz"
  sha256 "540e887554df701438b69bc861420751506ec8ef58bbe1fca0051748a92e2a71"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "775d39e1146ac25b23045d463359f4ecb623b2beee2f0eb64962b3c1d888bd58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c264f9f27afe41427d6dd7641a264b14fb3ba577df3a4609aadec23617f2e3"
    sha256 cellar: :any,                 arm64_linux:   "76173ea6ff968953964ac9bce548e311ac824bb8256c36cef4b0515159f3911d"
    sha256 cellar: :any,                 x86_64_linux:  "050f4f593b984fc9addde5d880bb3ae250a8465282ff33491d093e933a7e6d62"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
