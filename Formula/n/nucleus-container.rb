class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "e4adb723c0843bfb2ff4536764d8c9928aea1c997389119a11ce444143574e12"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "d9785aca9d327b19b5c013527f53e7c4246397005d766d19f4f7f33821a778eb"
    sha256 cellar: :any, x86_64_linux: "e6b8e6ca5ed10aae88f3b6a232d8377751a8aeebb907f92b6a4107c8a59643b8"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/nucleus seccomp generate #{testpath}/missing.ndjson 2>&1", 1)
    assert_match "Failed to open trace file", output
  end
end
