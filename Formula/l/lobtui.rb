class Lobtui < Formula
  desc "TUI for lobste.rs website"
  homepage "https://github.com/pythops/lobtui"
  url "https://github.com/pythops/lobtui/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b2c8b6b2c7acd7e0e91e013ae2ca8d1f96b70dedd7d5cda8b7af782396b3c2e1"
  license "MIT"
  head "https://github.com/pythops/lobtui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caba4a44543973f27a3f04cea2ac3e3473f9c41e7ab63e28b296e4bc2c49ce61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe6fe6a292a265be05ae8d8ee332a804b48700ce329f8c5c12c0318fa623eefb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "333ac62465a4b6a04fce5ca0bd68323152db0cd8b8c62ebdf0554b550b0deb3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2888c0f2e56f094839be9557b8fb5c351725954284e9e68c45f31fd379ad3595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bd8855ffe067d4dd5664263c13e766ae80f374696c30cea71c665f2ce427ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lobtui --version")
  end
end
