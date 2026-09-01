class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.31.0",
      revision: "d67f14fa3386ef3ad3dc76b347117189bae51ebe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab2b6eaabab16c7e99cc19facf9db501177db5f45e01d70f97b3084d76475bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19dcf4b27166e23fdcf627fc5350f1f8f467ec050b6aaf60afcbf33ded3353e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d3a95b6d9173b5d6c32231518c84ea6a1d9e7e178a9a2a6ff04be0aa015d1aa"
    sha256 cellar: :any,                 arm64_linux:   "5477eeb7bd89376fe07cc03b7a50ee40be95332a6ef4db6adb212a4fecd0de11"
    sha256 cellar: :any,                 x86_64_linux:  "adbfa7af0b7cb3d54636b0712f4d46514ceb3c60a8af94c2a0bc25e6e0081d16"
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

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: No such file or directory", output
    assert_match "One or more checks failed", output
  end
end
