class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "159048700d1e21846279516d67763353d3dec8b4a79b88a4e1aa5a657ff69522"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f5ad775e6b2f8afa890bb15c31cf7805e6a659916b0d9fd0634996d13d7751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4487b2ea5628a9a610be6780c29a22ee6ef5ed3b856ada4d589b18e3241c7077"
    sha256 cellar: :any_skip_relocation, ventura:       "f1849d9bd623c6b00febdf6f0b884ad153fef95c427f49c77cf1d9e7dcee8337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4fabe2a02f5be777387bbf177fe1f748cfa5d4264fe92ebc64afe59b7568bf3"
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
