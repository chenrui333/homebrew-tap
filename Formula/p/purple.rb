class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.14.3.tar.gz"
  sha256 "75a728281e353208bb9a7c4f83c87eafc91993083040c37206dd71e9964aaf86"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24a5082eb5235842467298df8430216b069846fb67c1adafc28377a4af4f7ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7996c6c41d609fecca64a6539ec8f4f491ea0f8b06992a22c4a333d4a1c9ad91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9063c15b56b4bda921693aebe331909a13cf57e9be477a82bc87fa1bdaf65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461e7418986b1bb2571a3b410cbea5bebe717abba81857a0d71a3f730bb560c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0debdac303ab24fb85fc126c0348eaa4209098fbcd030d80a0b3d41d856e913d"
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
