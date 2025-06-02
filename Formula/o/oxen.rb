class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "f8301be0615b5e489ea7ec6811a04e6730424c05710b22453b3b1c66e946dcf9"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60fc5d34fe319aae4756e17230449c4cadce7518bfa7ea20fc76c6daa2ebf197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9824329243bf1db2a9320dadc21b4f8f24bf6347901d2ef533114876288d8e83"
    sha256 cellar: :any_skip_relocation, ventura:       "a8e502790cef53588cb1cc7d3e2000ef9b1d1874d91abed8196bfa932c0bc1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7422c482e84d19b3cfa5eaf57c36cb0db71365601ab7902a47ebcbc892ea584c"
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
