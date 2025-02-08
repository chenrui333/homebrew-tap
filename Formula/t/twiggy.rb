class Twiggy < Formula
  desc "Code size profiler for Wasm"
  homepage "https://rustwasm.github.io/twiggy/"
  url "https://github.com/rustwasm/twiggy/archive/03aa20f06cd7aacb1c890c164037f860f16fa9f0.tar.gz"
  version "0.7.0" # bug report on the tag, https://github.com/rustwasm/twiggy/issues/750
  sha256 "e46bf450066e3eac0e95d06b3249760f4425e22477a55293566389ae27273fb3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a9ac9898684d5cf4d69dacae7de9330ae7405cfa84ab54b848bd1e2f51f7242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c5f750cd91d00d1f6149be12fa2b2535bcfeed643a7fc08912614d89a6a8b3"
    sha256 cellar: :any_skip_relocation, ventura:       "1f912ba5dc338111261b6a8bd1e8c863a4f0046e0a720c188f528a38d8af1bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6c5c43a84823d729c9b8903c87b6da2f2d4f5d138a2533d500ad2462e68849"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "twiggy")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twiggy --version")

    system bin/"twiggy", "dominators", bin/"twiggy"
    system bin/"twiggy", "monos", bin/"twiggy"
  end
end
