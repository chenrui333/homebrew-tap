class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c44e2217e22f8f4316006361ccd0c092721761807f1d88436fb901e6281248a1"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd51a6f6dc4489e80cb0ab4c5f323bd3ba011226b0fff2fcdf17ac294d5892ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721fd217ea4068699c3b0dda1368485f6b999aea033eba0ba8e370a9fda220d9"
    sha256 cellar: :any,                 arm64_linux:   "64cf8ad4165f38236cbb53e9ece6f649d1c510689bb70a2b070da4849d44a424"
    sha256 cellar: :any,                 x86_64_linux:  "c5a6867bd34b5fea11e543900a5e44fbdd7549d54fc6a4b948886dd017b1b3c4"
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
