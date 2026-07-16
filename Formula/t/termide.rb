class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.4",
      revision: "fb0d491b884750f7d2b417594f45480b7951ccba"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5afa3e93f7c56ab7ebcb44ef8da38bf936f3d9affecb56831a73fcd096d2a739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edac0486a4a15dd7322adb26b9255c455363c39ce1a10d0a6cfd61e7f6843305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ede39c8d558705c70881b65379582ce35ea6fd3fa669d210e9b5810b66aeb58"
    sha256 cellar: :any,                 arm64_linux:   "0bbc5d3a6ab4b951cac6960935db2c59c37ff3a1bc7edbeca9408c96cced2a3c"
    sha256 cellar: :any,                 x86_64_linux:  "5952bd04afc0a9ff2f9a2b6b613e08524394a6a8fc2757422c51888abe8a4ac5"
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
