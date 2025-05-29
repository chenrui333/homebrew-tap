class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.8.tar.gz"
  sha256 "668e0ccbbf713e4875ed11366fc155af850531ae18517270c579ae9200174c1d"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035e9a8590ca5482a43cba8a3cbb1338d1b6b24f80d19059f01127f324506d81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329bc436867e189cd31b01fd2eee68e53dde760711139c92a4fd235218fc3602"
    sha256 cellar: :any_skip_relocation, ventura:       "e7cab74283a22d335e72aaff95b7083e15edcf2120b5d12af9d2d3b8d63f40af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5461a6967b628ac4100793b3a37cc86bf60c4ae59d35577640a2bb4311340890"
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
