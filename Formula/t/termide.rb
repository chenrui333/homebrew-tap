class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.2",
      revision: "657ba711c2d70f27f8a06a12a0b770c4b4b3eef9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d57386809ff9167d9719c38df6d7a3aa8678d9e1745c0d14893d2dbc3eb638d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3f95ebb3fd6f88a9dde7ad5b6fb1245f450b6a5a3620e3c462f402771653b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "704bf3a73fddf7514bc689a4eae71a745388a6474ffa9af20bba18ecd6c435a6"
    sha256 cellar: :any,                 arm64_linux:   "a972723f26da81b5eec0e1ce0e5566b3f070347fceed61b4b36f532db9f0f17a"
    sha256 cellar: :any,                 x86_64_linux:  "3a7c599133b29287576cff3421aaca7c72c1a2d1f4f9a04e159c6d4e29dd9da0"
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
