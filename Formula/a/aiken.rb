# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "d222a0d4319a13b04045ef94c538e6b770b7cbbd3bee75fe4caf15c60cf6f80e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa66dad637f93adc1576ad5c6cd5d4200c740f04efd57197e58c5a0eb8bd9a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e036450a96b4c3532e5b7dd90588e3c682865324b1561d51e11c262aefd4d15b"
    sha256 cellar: :any_skip_relocation, ventura:       "5b37b252cb4fc1fe2c43b06fd3120da5ea6e4d8e71e32b99a5c9b970bd8bd657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "220c57e27b09b903db604cbd4409fd2288d615fe53c3f13bd92ada6484bba3a4"
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
