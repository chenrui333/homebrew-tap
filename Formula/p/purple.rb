class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.26.1.tar.gz"
  sha256 "c624478339894e5e9a8f3b760eeb5799b0ffe283b61e0961750341ab33fc7e14"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ed54101105e7ccb25e905d0898fd573d94e5f558ac58893dd35ed4cf56334b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922d382d851febf4ffbb0fba2d65f866e45f0e70beb77d53fbf294063b8421c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd63f83c56cec5360371263d2241eaf9cb23d8a2162de06cab742d7c51383c0b"
    sha256 cellar: :any,                 arm64_linux:   "82b33073e75cb6359ca559b2a4dd76e7602e920042e641465dab858e4214c878"
    sha256 cellar: :any,                 x86_64_linux:  "52a0e8b68f8a975674eec1a8c00d66e247f795ada09c3176eb7999a49cbbf015"
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
