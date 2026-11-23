class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "e4adb723c0843bfb2ff4536764d8c9928aea1c997389119a11ce444143574e12"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9b51244b532c6f3880545f361996e579f322095e29339f4502ac8867a59cac58"
    sha256 cellar: :any, arm64_linux:  "8a06ffe79c752d9b603088d029fd4713de776243d1fd734b861ccac2d822203f"
    sha256 cellar: :any, x86_64_linux: "b821de03fba99fac018bb5f75d1e5a54671f04312b6758389aa89fcf224b876b"
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
