class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "b5b649704862331fc205df8fdb27bc805c5b2b2f0983b840cc113ec199458336"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d1ac943f419da12a51d80bc819a406b0e296ee5072ba041234b7b527f04b23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b403ad4d256096c4ec95f691f0df40062dd4e8ce3a9b6b75d810c40d18dc104a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "122c4190ae9fbe4c910f3508449fc12d2ab9acd61272d4ed3b22f93274f87f4a"
    sha256 cellar: :any,                 arm64_linux:   "310875a0c576f26c07256c3b174a890d4960d2fc28cd8a73d21587b4492ee6e7"
    sha256 cellar: :any,                 x86_64_linux:  "3898f195d2d78d4ebc3503babf0ec647b33d991421c704ee13e8026cd7258c72"
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
