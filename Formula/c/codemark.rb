class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.8.0.tar.gz"
  sha256 "bb191ed81dad20efcd6d155b993b9046ad22439547b8df0fa486feee26c2a65e"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "438b2fb3f44ee223896421ac7874cf049118605e5a73c9481922834aef5e83fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1507825e653fd98228ae03eaa7641fcc837ca28e1f05ddeadb9b9ddcd1bff15"
    sha256 cellar: :any,                 arm64_linux:   "81451ed200772cb91bb11eb0dd150eb5fb2e1d3cfdce0222063eb528ca25f28a"
    sha256 cellar: :any,                 x86_64_linux:  "3b7e5f6f858e1def91cd32da56b15316e757e0ca5be6b04c0174d2b6259c13f1"
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
