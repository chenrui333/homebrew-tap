class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.4.tar.gz"
  sha256 "97c91b69e0fb00e3ecd27e508b20e4be247cba5d704022c2b08e23f0134778ad"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d971ceb6b27a8ad983eef4c4c0a8491cf8af616374c03054c73b5fcc424b063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445d67eb5404685af979165be63f272bb23e2585d5262faaea01d16fcd4fc0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8e84762c2e8a057f5981364c57d302f0e38f4cffdd3c779c94182fd66cf8a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e6578d5d11cb88016f33ecd61d55af89f0f60c83a39046607bfe16c5611447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d8b59d1400089c9c040206959bb20e981625138b2fd26025e2e556146d7069"
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
