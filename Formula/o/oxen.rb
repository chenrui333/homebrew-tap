class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "8ecdbe55ea4ebd4418843bb9f02ee0448c45c2947805fac60839cce1d50c8710"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07e7bca77904595a56ca0f9b820f28ec41d6919c09a0efb6d11656e5eb8996d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14bda76aa76241f6df96458af5f70f9f0310fac3b5453c349930e5f9ca563ef"
    sha256 cellar: :any_skip_relocation, ventura:       "32b599528476525612b2afb56bd4d47ffc8c10968f5f2aea39e504a9f76676fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15b01abb9779a7dbb398da106a52a6ce8069552ed6f2c99621dfd0e7e25fa2d"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
