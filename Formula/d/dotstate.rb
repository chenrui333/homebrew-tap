class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f571b8582d67931d0eea41763b86ce8ed6c8c577d26902c42e59d19008eb80c3"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dddba082fc2d6da2565ade06e44ae8f8f5a3fc1896658b2d2d2a350d90041f65"
    sha256                               arm64_sequoia: "f365a71607e6714a9ba435ae0653e12b88d37d79ec1756b46afc96eeb34ced66"
    sha256                               arm64_sonoma:  "aa90f1d2ee03ba3e0e3942b6ab36d6aee2708e98f81842d97efa528a7dbcde74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3168c9740dc23a9aa02e0573172003535be6c82010719c9982df8f2aaa5fb2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354cdddde50ff0452614a37091cbe06b8cdb87e96c0a973fe184e661919813a7"
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
