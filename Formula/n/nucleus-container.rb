class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "61ffa624c8e088e698b5ce9aa4ab6f9b59314a7718819fecdbe59a1cfb54c9d3"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "dc386d59b1ecf0fdcdd63f4d0fd9f599fa998d2c4ac6886498b0a5e53b6fb5c8"
    sha256 cellar: :any, x86_64_linux: "8457ecd568800c0d146db169695d9656bed076a6acebb013a265194e6fb129a1"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    if Hardware::CPU.arch == :arm64
      # libc does not expose these x86-oriented syscall constants on Linux ARM64.
      inreplace "src/security/seccomp.rs" do |s|
        s.gsub! '"fchmodat2" => Some(libc::SYS_fchmodat2),', '"fchmodat2" => Some(452),'
        s.gsub! '"mknod" => Some(libc::SYS_mknod),', '"mknod" => None,'
      end
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/nucleus seccomp generate #{testpath}/missing.ndjson 2>&1", 1)
    assert_match "Failed to open trace file", output
  end
end
