class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.6",
      revision: "b7b4aa147b38710041a33db6a35c56d75608ee1c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "456c223d34f5ad0eb726f8a8e67f81637345713d85bf4d29bc653782e11926d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda5ae0757c9f928fa338466884f3b5e4919eeba069a7969e605a38fa5e78b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e47f5c9559de73dc7e4254eb5f2aefda16157a5abd762fa2f918887fc582284"
    sha256 cellar: :any,                 arm64_linux:   "fd4062de9e76b62a0e4fe8dd1c61590b406b44ca05a31f46341356c869d618c0"
    sha256 cellar: :any,                 x86_64_linux:  "f0a5c20546c30f5e1184dc5482a70da442f1b73655a2806cc1afd8cc8831adcd"
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
