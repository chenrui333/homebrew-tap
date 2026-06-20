class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "f8b5b8e47c5d03eaefd544eed6a7b1f33494e4c36ccaa57edbe3881780f431b1"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "569362a569970253848ab33aa2bbd67de8a7b6a619b3a44c0598e2fa30c07878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "525eb15157eaadaa64ffb1c8c78c0fc5faaa594bf5bb1df20c851675098fb084"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bfab7a7fa53fba8d8e4c592094baa407991b001eaab55a7f89ed1dd96aae121"
    sha256 cellar: :any,                 arm64_linux:   "b81c70baf5b6e730624c7a36f2feaf92c6aabe3ee5b01ac28f63f744ded0a262"
    sha256 cellar: :any,                 x86_64_linux:  "33b84832247e46ddc9e0b0af907bb8dc8fb6846302a5a4fd9709d2378865f708"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Cache cleared successfully.", shell_output("#{bin}/rustormy --clear-cache")
  end
end
