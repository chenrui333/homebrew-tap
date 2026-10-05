class Localports < Formula
  desc "List network ports with their associated binaries"
  homepage "https://github.com/diegoholiveira/localports"
  url "https://github.com/diegoholiveira/localports/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3150d5b411db846822074ab0ff87a580e8679752986cf028e8da162d12245be5"
  license "MIT"
  head "https://github.com/diegoholiveira/localports.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27deaee8dfdab1e8d025e71ec2caf9bdced92f5fa2cbcde7d26d692a33babee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5819a4ac6c0dc453f814589b5d95a16bf7c82d2c8586c4a0c20320e173af8e"
    sha256 cellar: :any,                 arm64_linux:   "f2b3d83c8c56a7c39482868c779cbf41ca9525e8902f80d5bdf947447b0ff4fe"
    sha256 cellar: :any,                 x86_64_linux:  "5871660a742315103a83dc338f221b6a86e599d9507449658433665c26591458"
  end

  depends_on "rust" => :build

  uses_from_macos "lsof"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # The sandbox exposes no listening sockets to `lsof -i`, so feed a known listener.
    (testpath/"bin/lsof").write <<~SH
      #!/bin/sh
      echo "COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME"
      echo "node 4194304 user 20u IPv4 0x1234567890 0t0 TCP *:8080 (LISTEN)"
    SH
    chmod 0755, testpath/"bin/lsof"
    ENV.prepend_path "PATH", testpath/"bin"

    assert_match(/8080 \(TCP\) \| 4194304 \| unknown/, shell_output(bin/"localports"))
  end
end
