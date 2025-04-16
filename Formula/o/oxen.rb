class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "a022d6ed3695a5b29ab4cd643a339c92acc643942157f000eba1d1a14c0e6bdd"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13836e5b7f0530a1312bf52dfa881a2bc6468aa98d12bf195de6816212f71d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8f6367ecf40123b7bd0c330b8a9a010cb8dbb792f1db25092a7a4c573d9aaae"
    sha256 cellar: :any_skip_relocation, ventura:       "bcf2497569b9c2deb9006fa5f88434e54bdd95f31333efa95ee9df7251497429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e66e26ada0d93b71efe396d7af08aaf6134e3c23134fa1319e4f5b5d8081c07d"
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
