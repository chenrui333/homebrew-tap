class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.8.tar.gz"
  sha256 "668e0ccbbf713e4875ed11366fc155af850531ae18517270c579ae9200174c1d"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e99681dcd78b1dc5f34df6b834d88f7f7b1f1ef921234ee5adf63270ab455f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e571cb8b4da806f8c5e030e1ad41a4da4ae18a4da142a76b7ef3a0293ecabe"
    sha256 cellar: :any_skip_relocation, ventura:       "c5752dcc46fb09625c9e3994ca1908ad4cfe629565a0c8f7973d3ed7e42d4dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f6466176b342cb48468d624a5a3399d3cd61ebe125cfbd68e3846fdd87a990"
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
