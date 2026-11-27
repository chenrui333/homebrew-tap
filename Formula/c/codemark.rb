class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.9.3.tar.gz"
  sha256 "dcd6a4af67394ee9a61363d03ae5eafd4d2ba5787d365dd1f32bd1b1917b3cf8"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9321e5d7d1e4a1fd4d3eaa301df3dcd722c550218e51bc75b133d7323230e932"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "753d231f004ef105328d4664d43a0666e0578d169dba2f4a543289f3ad57076b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03246b01fec0bfae668b9aff03752c58ab1b1dfc5866d8570e6db0bb13eecce5"
    sha256 cellar: :any,                 arm64_linux:   "82f1e30dfb349c38a2149e36769400b96afb8b7ca24d360e9a9844e2619d9f36"
    sha256 cellar: :any,                 x86_64_linux:  "c08b973a8d5fa2de46316a6da9a7f62711aa6224b066cf8f3a522b625e546f19"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codemark-cli")
    generate_completions_from_executable(bin/"codemark", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codemark --version")
    # Other grammars are installed dynamically; Dart remains bundled.
    assert_match "dart", shell_output("#{bin}/codemark languages list").downcase
  end
end
