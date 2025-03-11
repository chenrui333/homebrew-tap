class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "7c917419233e3c9da8c097cec54362de1e69140aeec87ff8f9a1666393b97f77"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17dfd858eaa06816edc6b0b6e694a03bb996acfb6a4a1dd29bd6195a3261b075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a69a4c4efcd4cbc5529e875c9b3468cb7361097a67af2781786babb65b84c40"
    sha256 cellar: :any_skip_relocation, ventura:       "3ba561f51e5ed9f7409db5be3848cf94cd0bd4cf1720dfe9348da12e9e326cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4128f47621e88136ab1c610148bbd1c74bd96c6bce6a5076806cd7083ce9e44"
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
