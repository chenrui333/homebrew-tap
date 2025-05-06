class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "390a949ea8fa9420b727359b8742ea784308c76f29989bc5cdb3cff0da9f5be4"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d54a13c0d0c04811ff4060243bcf7365ec04cc5edde3bb3bf714ecb089344d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d629be1bc72c7e0b1d2c6817338bca09b9062af5b85a084edd0a313bcf814b"
    sha256 cellar: :any_skip_relocation, ventura:       "ea28ef9ce5f0bb4cd4a934e4c048857a4c0211923f61f89ede6fde3a830820a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2411930c9221df4862846f9c1dda0989087c5ccd7c3e6ac95c657568123877"
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
