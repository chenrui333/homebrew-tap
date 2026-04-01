class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e4d5a91f3c8df5ef4861bf39667b95fd1eeaf3ad18ec51bf9f16ff7baca28d40"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b7860e043b90922b3ea142b653fefe5a059c7912be6bd31d0d32bf94ba25fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71f2bdcb35d33a80d217c8599dbb0e8cd4eeb8366a2cbfbf20d746f2d66c43fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e451f32d0ba3a9f15a7386f1c902e1c1c79198c39d00d199eea9e028ceb47f42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f48c10610d6e91ac7cb9031ab31c893b96d8dc363e340aaadfc5eba6fc82812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a835d53a7a7326fdf090fe600a17f78171b1bfbcb1fcff8e3c9c54411e907bd0"
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
