class Agentcarousel < Formula
  desc "Unit tests for AI agents with LLM judge scoring and signed evidence"
  homepage "https://github.com/agentcarousel/agentcarousel"
  url "https://github.com/agentcarousel/agentcarousel/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f5aaa51f3a8d1fe4e139b99945d39590a858e78b0f5fd02aafa5c385cae13007"
  license "MIT"
  head "https://github.com/agentcarousel/agentcarousel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "accf09d0dc6fca434f06af2f335f46259e7f47f78a71547998ce54641bb3b986"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "606c74801fb3d75c532f5cc6dc59832ffe8fc22fab5689b33749a088ba335c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35741a8d3701d3e1b6acd8295cbbfb1d62aee8e856643e50dc648367ae088af1"
    sha256 cellar: :any,                 arm64_linux:   "fd3fa8df36cf8b65f89a79f90bdac6f87e8d6b443ccab37bc5cbb2846d983379"
    sha256 cellar: :any,                 x86_64_linux:  "8c6251a470f0114b5cfc9e5fe918863e0981b2a49baf981bae9b87c069e5ea56"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "crates/agentcarousel" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/agentcarousel")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agc --version")

    output = shell_output("#{bin}/agc validate 2>&1")
    assert_match(/fixture|found|valid/i, output)
  end
end
