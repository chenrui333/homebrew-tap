class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "ec8be89267ee0e7bd44eae6d4d1c2e43affee25e7376f9b36a8a95ae3eff50c3"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b072cf2f1f34461b5ae5e82ce829bb568778ca2f171c4743a2c9354b66c4af6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3b490ef8c42367e8a94736b674ee5bb2126751c2b9ecbdc6e184371fe0cc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6acfb9d1de6a72ecd52a4f7adf5f5c48a15fdc32e3342983e8777d5c4e81695a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f07f3446f2e0383b0ce7849d39d8f0acbe92ea5c93ed042793e62f31cdeeae83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b507b2c0ad02ce931f239f98eb82a3258b58288e1c2771bc0331b6d4e1b1736d"
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
