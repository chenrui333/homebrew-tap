class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "d39f6a7a6bf3e827da429e04ed43869e17e945ff5807d26b875afd4ce90d685a"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b55dd0699347a1068944155b56295bc072877726f8c566f63b51cf5fb83d3188"
    sha256 cellar: :any, arm64_linux:  "89e7492b596e9101ebeb9c6d41e1041d6ddc866d8bfd6fa9ec8e882ef3ebad07"
    sha256 cellar: :any, x86_64_linux: "9639570cacd98c13937b79787b41afe1da1990da16c846be0029d38e8e87c564"
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
