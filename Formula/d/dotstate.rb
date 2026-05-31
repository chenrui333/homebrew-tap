class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7b1fcdcd7f1317d6b25f7c71f9d7128c5a6da85aa40ca427131972f36c78de12"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "f9dffd40e2b1292e105f73081cf40cfbe014a6853e4921f302037d899d0b5ebd"
    sha256               arm64_sequoia: "6e174da8f1a84a26b8ac8df7142b0f469602fe48cd0f3eea08639c4886f1cddb"
    sha256               arm64_sonoma:  "b5dfcbe295e35d75aa0b72f5345c189c5afde69c28c975180d0a37aa51d2b4df"
    sha256 cellar: :any, arm64_linux:   "b4d578ea06a754cb3d4d09c4c7d5a15d85b6ff44027b866de72af176d9871189"
    sha256 cellar: :any, x86_64_linux:  "f76eb10ea62420db2ceb05d7674c362de65bfb1f3a51ad1ba6af9a83fccdd851"
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
