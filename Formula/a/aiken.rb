# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.19.tar.gz"
  sha256 "87a74203a8ff4a82aa8c33f07ed4f5fc1fbda9c69a38b13bd2abf24146f9811d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901d949f776a96b980dd7b4317f3dd12db121ad4ed5e6ef324a928156b7efe83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a87c4508b84e75428566589065a6bb42d04f0d74ab1608a3703c56c97ad1bf5"
    sha256 cellar: :any_skip_relocation, ventura:       "c8e2faa5f78a0590c8abbce86f9e7a171968379e3f3c07f68936fd78fb7691ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c5ba9a14b6a2543edce4ac0938a8aebd86d469f5dd87a4dd2fe979e95bfa74a"
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
