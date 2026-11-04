class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.34.1.tar.gz"
  sha256 "25cb31160bca5b7898d35f935effd608540d0141c1be5da69f8586791000f6ec"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc5e216626d686fcd8b75aa7082b960827844f81c7d16f3aed5de04f27e3d6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f894d9e786dfd02f5acf716cd4f2dedf9201b7d611cb0ef0b77c567ff0b355"
    sha256 cellar: :any,                 arm64_linux:   "7efd9dd4bd7b1aac9a4076882eb0d003100bb1255f1758b4dca9418d44d80acf"
    sha256 cellar: :any,                 x86_64_linux:  "22951bc5b20da4104575b1942974e4456585cbd142590a3e75ec9f140b00c88f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")

    (testpath/"ssh_config").write <<~EOS
      Host tap-test
        HostName 127.0.0.1
        User nobody
    EOS

    output = shell_output("#{bin}/purple --list --config #{testpath}/ssh_config")
    assert_match "tap-test", output
  end
end
