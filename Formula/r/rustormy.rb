class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e4d5a91f3c8df5ef4861bf39667b95fd1eeaf3ad18ec51bf9f16ff7baca28d40"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b0caed710a819b83d272c5103ba86c8216d565f55bcfe4ac2a014b94a0a839d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c92ee569d2ac4368ce4c07bd768eeaafb5b8224058dd2a25060937d6fb08d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "313b1115c4a8b6290a6a5dda8dd88bff8dcfcf56a48517309bee4ff3a8503a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098a221c60dded907b829f24047e1035fbad6c996df2a929adf15acab978d5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de60f78bcc2628ad33d783bb3989933b2152dc5bde4afe7dac8153a271587b1b"
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
    assert_match "Condition:", shell_output("#{bin}/rustormy --city nyc")
  end
end
