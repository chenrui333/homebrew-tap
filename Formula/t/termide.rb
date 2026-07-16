class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.4",
      revision: "fb0d491b884750f7d2b417594f45480b7951ccba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45310f41eedd300e8902ae3b7735f5a81b3145abbd1ec80c0b1e5f2a18fbeb53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd0da1fb43c34fc59176590b06bb9031b93c54f349024ed710d19162d2352e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76792e7fd0db46b587dcc1b3f2380eb3cf78b7bc5c775f1a9bf2748b5c099e8"
    sha256 cellar: :any,                 arm64_linux:   "fe62785c8061192b9eeda6e748e62553ec0f749bea8a1e687247b5eda205b1bb"
    sha256 cellar: :any,                 x86_64_linux:  "0d106122d4628a15c3d767a3ab0c0a6cab07b62a58825c72a938e4671dc57b91"
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
