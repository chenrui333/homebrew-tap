class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.5.tar.gz"
  sha256 "119ec904623f33c2b928a249cd5feca32b017f92365d4f3f793dbaf61fb0465c"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a47f6f376c45e45b76caf0bf34006594ce2cbfcff8ae6739a2e152b887d299e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1b5ba5eb57ca8d2be7e2c927c72632d584f96f44eef33685fdf021779358ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2c3bf42f686ba3af3dee41bb89c4e61fc63c27f97624396d41e978d76173a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b31ba6074b42fa7cd37afc5585b78556635e6c9f267c3ecbb3de96d786a6845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bafc16c608aa465b7f088300aca77354f4cf3e4a64a9a133dcadeeaadd947459"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
