class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "390a949ea8fa9420b727359b8742ea784308c76f29989bc5cdb3cff0da9f5be4"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b826e66ad98ff2a66dc4668a98e1fc652b2562265bf6ac4f9f29afc3be1f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1144c384b4c472092948242d0f8a1cfefc6327ad81baa6d78f3a9546f0d8fd38"
    sha256 cellar: :any_skip_relocation, ventura:       "08a4830ba7815f19f1c397e2145b2b06e108b025192e3689a94dd9224641a0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28efb7cd8a0692639162da1e4562e9cd588949131be2031043af788e8cce6ae"
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
