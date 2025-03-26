class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "7f8b9b1c5f25fc123b57f2c444c32677801c85d80d6bde8a3fe32e02ce935be2"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ff039cc899a9d59a8b5268d7e633a854116f640599b332916476cceef9ec3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ed73b41485daa91df60959ac2a019832fc718e09b81074824e545b367031ea"
    sha256 cellar: :any_skip_relocation, ventura:       "3b3309446aec7250e4b30c52e0983c2e47cc4f186032802f4f8e4563ca68909d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678d84716ce4a48894879260406812faed5c374e60e2921fddccd63b7e615912"
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
