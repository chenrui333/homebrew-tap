# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.14.tar.gz"
  sha256 "1103465d4a60a0d8d259bcc53e813d13f90177a8a46d28b5ce29d56a1e184b89"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d46fd9318eda9a109995fda79a5510e0959ff8a16540988f3f6d8c56cf56700"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c1b89317ca95069e7890b934f880eaeaf564218692c4b4941c23efd003606eb"
    sha256 cellar: :any_skip_relocation, ventura:       "74fea5ef0a73441b1afba8bfdf24ca4664ec3efd867538a27b92cfc1fe05e9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801d90093c7416ad00166268505ccc0105c42c0ab72129f1e2ce55e91fa838a8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
