class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.5.tar.gz"
  sha256 "2785f48d4c0bc553ff757a98d3007144ea72199b8fa9be3c02afd2d2e1c214da"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f38c500515996a082ab48bd0bde808ee718bf108a7dd14bcd7b6d4a87013ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b78d81d7b78ec03bb0383e6d37f8e2a3cd7e27c247f84536d18439a17c77dd2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e6606d2a611c624253afc754dd033a699d669077fc92f842fd6fdad5e2db966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b7698e2f41fa440fd7acdcc5c2b245bd32d67930533fbb3a417ad9a5803adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad09abbe7f638cfe2a5a09be6e8211f2f37709f48dc598edf9221eab70b4b137"
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
