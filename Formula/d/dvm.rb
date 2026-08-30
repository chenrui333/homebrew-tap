class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://github.com/justjavac/dvm"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "88cac180e981867beb96645a223808b55c225ae98fc5ce049bcba12419c7eb30"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a90bd91b7eb2c772f120b099a2356672d526c1db4a47cae4105a9d5e34a66d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f94daed743c92c22748c20eadb728cd5bcb7f4d3c919fe6efa53ff7ae58737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46403ed489337dfb087e70cf86c90f2e5b0570efabb0829a0c377d46ca77c28a"
    sha256 cellar: :any,                 arm64_linux:   "ce8bd23eb660c68d38f1d04fdac8a95ae61d230f86eef8b6bd631bc9d4e2020b"
    sha256 cellar: :any,                 x86_64_linux:  "69b9e8e3bcf472b85af6bf9b72a58e5b239eefb07cf313db5646d051e2c6cdc4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    output = shell_output("#{bin}/dvm info")
    assert_match "dvm #{version}", output
    assert_match(/^deno\s+\S+$/, output.lines[1].chomp)
    assert_match "dvm root #{Dir.home}/.dvm", output

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
