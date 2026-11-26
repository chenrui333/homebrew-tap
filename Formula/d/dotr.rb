class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d9e64ea93679f996fcee458bb058fccda36e220030756abf6528a6963167b9b3"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9899bdc3b0d2ee9587445f2c324f14919d49cb0e40e4e6b81c876fee873c7ef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692eaab7cbba99b2220ae1b8e74c11a909a47f71264dd91098d1ffaab6ff5daf"
    sha256 cellar: :any,                 arm64_linux:   "cb3125ef9181ac473c6e35b3d6ec607ace2dd138af1466f5499e1abf1978a75a"
    sha256 cellar: :any,                 x86_64_linux:  "41199441cc1c6f3fb90baf612ab0e3390cc3c87551d8342da3fbd4a1821b6bde"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotr", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
