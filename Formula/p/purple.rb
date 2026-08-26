class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "8841c08f0660c198a501a48902e3a8ba2a133a1699fec28eb21b2e3e80b4b282"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1207d969915878610a9682174745cd3a43c0bce3bfef7259e1dd1633a9ef9c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4247dcbd34fcbaad854c43f575470f0b52e3d88beee8304c5411a85c8dd1854b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b914d00190976b6d2bf5d6d11af6a6ba3e365037a6d4272f42a38586c5259f08"
    sha256 cellar: :any,                 arm64_linux:   "1025836de1b97a0529f2c9263824a87f2275d2480e38f80782c36fb86bf1be63"
    sha256 cellar: :any,                 x86_64_linux:  "f624e9147ba0e0d6ec545dcfbd13ba9693a4cb6a548df77c744a7a16b6f6bad2"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
