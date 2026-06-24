class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.27.0",
      revision: "8e2a3a6f1b8b76b7993961b7a8f218ae0dc97523"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeda31bbc566ef03b9745b696100a64fee8bd7be724ab83ad2e3f5a33a9c76f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e5276c30912d2850f74be84c2d0c02900d670d539bc626a0ad7031e9e39d88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b1081c074dab7eadbbdeb9abb61971e5e93338983a034f727c2e8e1b114dbd"
    sha256 cellar: :any,                 arm64_linux:   "3e9bac0356a37d1acc5499863dead2bc4a0ccabfae1c41adee0a6699ce9a61bb"
    sha256 cellar: :any,                 x86_64_linux:  "e08874fc061fb49d9fc9ee01f15a4e5a575210e60ade537e22cddb797f348a7f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")
  end
end
