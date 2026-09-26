class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.30.0.tar.gz"
  sha256 "3a589b01d02c771afdb2ebf63bdca0fcfba6d0f3be13892a745e617c59e860c0"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53680e64f05a0859fef50545d7b4343a4c7370ab53f0a70d1bd5fa2b9c1634bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb78958c344ef09a408c16149ef3a4087a384614071dafd297a34e27868b23c0"
    sha256 cellar: :any,                 arm64_linux:   "b484beae9a6944703c54815c4dde1e4dfba85ade71c91f0fb612123d5d11f146"
    sha256 cellar: :any,                 x86_64_linux:  "7d9cb5930a6439453ec25a50518bd2ca322a3cc2f6036ec948966c7bbf09b256"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
