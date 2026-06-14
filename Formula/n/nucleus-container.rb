class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9e5d465c55e192142186f919de5e3b9134d4796ec2c5bf0f215ad8537cc0ec6c"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

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
