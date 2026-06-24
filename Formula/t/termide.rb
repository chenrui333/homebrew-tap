class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.27.0",
      revision: "8e2a3a6f1b8b76b7993961b7a8f218ae0dc97523"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1940ce70a71c5887816af978c6baf8559bf6524939f58780ab7831efed7d48f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b70a6f96f75ffd17614503799cf08ecda9d9e01c0214306e10859310a944c6ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b60981c96e21c6ed0036caf0b61072f96a88846e22675906196a067097eb4b8"
    sha256 cellar: :any,                 arm64_linux:   "8706ceb7250a47c0ef04d3d6614c720912738ede9213f6036e4e3f5870417af7"
    sha256 cellar: :any,                 x86_64_linux:  "9988495c9d0fc31a64f61cc7781c03534d3a7c955ca26c5abe53c3b31564f462"
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
