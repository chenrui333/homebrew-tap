class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "3b54f914f36750bd1b6fb9152afb21c2432cd6b03b028340b5b13e9b8dfce2eb"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6b7d7907747e9814c919cd26e915ab60657359b1b15d7081c571bac5c977ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802a73706218bf6ab62b2a97393c5c389f6f6460d0599abea221bce7fab8b5b6"
    sha256 cellar: :any_skip_relocation, ventura:       "732b141af58795686851ca06bb300eb45392ca1a6bcb34163203ec0e39fa255a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48e68eb17a495b0c2a3541939cbefeeb3f172ab1c56f17a61b225e03ee220db"
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
