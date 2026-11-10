class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "b0f8b7857f1859b2ec808a7b2842a6ae65ba9814db3313d30577be10b000d546"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a962cfe24fb9abfb32393cb188afa9797a22e6f8d3cb336410c0609c381981f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300ce3530dfef2657f4a3ce2151361ffffe54a505682a4a4ffe090bc8b25ca20"
    sha256 cellar: :any,                 arm64_linux:   "31e9a878b84bc387c062e0a17c10f9bc8941290df1bbc76233e3ac6c675eab5a"
    sha256 cellar: :any,                 x86_64_linux:  "7f0d14056ec7f3de9637ca745c15d610e346c93292c5ab1a89929f5ad7978c24"
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
