class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.5",
      revision: "45a6f38c7f0299b863de922fb105e752fcb0e93c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee502cb95ce3bc27828c5d2194522664ad69a96d28ea03f4355edb4c672c20fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e232ef30eafdf06ca7c0274aa94b0e4779dbde51721bb0b116211fa6bfd9734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92cad91a8e33e43b8fea203aad868f7c8fbcd7ce7cf354846a35ec0470225007"
    sha256 cellar: :any,                 arm64_linux:   "0084f3a9234121b94caaa7fa69a2967fb7f0108080063d763c8363fc6ca9a3aa"
    sha256 cellar: :any,                 x86_64_linux:  "cc48f09b3c9329ca0a30c7b9e74c31dce3f959f8434ef878d9da4384378cc23f"
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
