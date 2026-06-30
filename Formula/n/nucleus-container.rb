class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "cbc69a620dc6e32387e5b6ccae1dca968607240a3de0a86eb7461debaab82201"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "61109142986878b14a9a046ac2ee579a512021283410e8e0a43f17e57c64771c"
    sha256 cellar: :any, x86_64_linux: "9e14abfc8e2e65176a0804bb933da92141bb489d77f21ed49eac5574c04cd223"
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
