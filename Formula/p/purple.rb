class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "8d7a24efa5d421e7deb709970fe8ce609e38e52ef46fc7ad0deffb263d6056f0"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd9fed6ce6446d998e998684b6b3b6538ad91c5c08654b292ddf75fafa731f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c7ad1bf26b567b0a9fa63a88dbcdf1cbbae7ca4dc9cf60e9ac2e4a76bfea0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2b1f38b1bfa69e722a2b6a5dd70e531a14fb987eaea9bf1f04ac8a0bafb418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99fab121b2e1fd74e9cf28665a4a3ee86eb3abc533941595e5b06db337754ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93913df90fcd39ba7d6c562ed0677244ecedf7d78974121da0df0fc29e6894f9"
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
