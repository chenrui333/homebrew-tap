class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "935f68e71f21acfabc46f569ae7f1dd2175bb333c556cd0de9b744eb30f5ae63"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c464c560f1f5c2302200d7fa29f95308fe3edba71b7d968fa36b0bef5e82b7ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbd70edc2c7f8cf0c85dd634e239326fde90e8baf509e306a72be6d0eb04e0d8"
    sha256 cellar: :any,                 arm64_linux:   "a0f490d927e14b21e64471aa89b35419ddb59bd96a384c0da1e5b79c1e09ac4e"
    sha256 cellar: :any,                 x86_64_linux:  "569840954cd753d9427ff957ef17c08ae10a1066cc7b4eb905d497a55df34824"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"dotstate", "completions")
  end

  test do
    repo = testpath/".config/dotstate/storage"
    repo.mkpath
    (repo/".dotstate-profiles.toml").write <<~TOML
      version = 2

      [common]
      synced_files = []

      [[profiles]]
      name = "default"
      synced_files = []
      packages = []
    TOML

    assert_match version.to_s, shell_output("#{bin}/dotstate --version")
    assert_match "No files are currently synced", shell_output("#{bin}/dotstate list")
  end
end
