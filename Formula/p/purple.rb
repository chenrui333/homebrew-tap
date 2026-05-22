class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.15.12.tar.gz"
  sha256 "271c5594477e0d6104aa7a4b20bb7aa0399ea5cd870395d981a893c516305cc2"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52bb419f012b889141ee7a9ab39ba7922a2a6608ccf0393ccdc637fbf8a78c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9852bcf57f8eb9a282f65d953a9fcf31893a4433e7e154170957da0badcd9467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36d8def852fa882c59655251ca8ec5b7d4cfba32cb83ab2cba8807702b8c43b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2f24004379638040d1e6169fa0d0af7a64d040b52854607ae21358b76b4f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9801b0e8a299b5bad092f26cfbcd82dd9c4be1972aa8216de5cad5276694fb62"
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
