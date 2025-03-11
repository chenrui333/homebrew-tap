class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "7c917419233e3c9da8c097cec54362de1e69140aeec87ff8f9a1666393b97f77"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c59e3df70a7bf084560cfaad7591b9a15552ca1558fe5ebd79797b07430c5771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e91471425d4499b1d6bf61d20d0e0a7a828016d18e892b72911c87b211b58579"
    sha256 cellar: :any_skip_relocation, ventura:       "312119c4562af746db986bf92d12512d40d7567e3adf3c5ade9f0af278e2f0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b44797c4d71b526a7656d734973dca0c759ebe036b4395dc079cef0afcb0e5e"
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
