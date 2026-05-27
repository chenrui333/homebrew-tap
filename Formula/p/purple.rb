class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.18.7.tar.gz"
  sha256 "89a9419d5ac369dca75a76dd5097ff710de929e3001886dcf4b5d8229a1e2c37"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e585b23f4e34cecce5e4fc44f0dfd830c9d72b187624dfc254c4715fccda23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d980199295cdb045fca8d740f1aa253bb30224b560593f7da8666b0ad6ee7016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a617b73c85171b2a998635ebdf4be44460bf100c51754a5fbcbb542aa8a83f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee5e8218696963582241466423fb6b24ea3a9a778c9f1c1b9bc3af7271372d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08201f89d71b2a9857a33b8a14cb09578e823c615b84e9a0a6ce8b17c9e39a3"
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
