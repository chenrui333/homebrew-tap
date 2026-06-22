class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.26.0",
      revision: "09663955c4e1af13724811c9ccc825940c4256c3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2614ed217aebc1af249d0ab07bd7cb00f1acde175bdcc21076f472008cc42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5288373479ec26c6923c4bd7acce76ea45b2f54b6267871b47d916d865cc7f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02e9b7b591c20a8e23730db67f3667cf8cee926cba2da013c9aaaa68c415532"
    sha256 cellar: :any,                 arm64_linux:   "f4c91c8dc75685419fded2f10237d86eeb67b71c076a8d06abefbe3ce6cf02bc"
    sha256 cellar: :any,                 x86_64_linux:  "9f7de875d2ec6864833c5c8e6500df3de518ff9819d10d782bfc2fab9188a45d"
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
