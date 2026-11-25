class Codemark < Formula
  desc "Structural code bookmarks"
  homepage "https://github.com/DanielCardonaRojas/codemark"
  url "https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/0.9.2.tar.gz"
  sha256 "41c62ccffbdaa36dd94e43c881801c562d50585cd0afe2ab85a5037c54f4ace6"
  license "MIT"
  head "https://github.com/DanielCardonaRojas/codemark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "94f2682671df912a33d0ce84f2dab98a6635121a65c3542b1d1f81ca825b00fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "583c8bfad731dc37aa307fbaccb2635ed2886501d1886b2c9121cd5cdc53126d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7570ddb4ce0ed4cc0d9e5c6f0f7dbb4ff5aee8e88fe36a7bc55079fc4c975142"
    sha256 cellar: :any,                 arm64_linux:   "a9ad95c66864652460a729f4b5015e2428b4e99f3677b63373d3a28a424ed06d"
    sha256 cellar: :any,                 x86_64_linux:  "a43b087665e4d59d460142cd65bffbddf5f268f1e99fd48a30e2edc4fdddee54"
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
