class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "1f01e549a6d54df7aaf1849d835b9b9bd94f7d38ebfe8d59d6b14891bbdf8573"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7582a42b3a611fcd79d030dd8a9cb336769ac49529029afe401110175b54d977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d31849c6fda4e432b8ad9c5df4faced4457a8d88bbf35baab37f962af03abc14"
    sha256 cellar: :any,                 arm64_linux:   "ccd00f0ab97e57c8fc717f887c65714ab09f22fd895a768f31d7562152180a62"
    sha256 cellar: :any,                 x86_64_linux:  "065acd59e5c65029910e42085ead686e47effbc69c925156123cb961db9d67e6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
