class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "04d30e1e70eb22345fd5c6713f48c92eb2d3f8012c906bc65284b66d81fc0b0b"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ee5dfb8d3de3ce125d85c68322bb540bab08ca6b9fe6d5d9a800c00c4b4e8998"
    sha256                               arm64_sequoia: "a59dbace6238c14c4e5c8ef74a1fb3c9414c98f83482c1f7bb1b0bbb16046f41"
    sha256                               arm64_sonoma:  "116a3bbabda36a34572381dcb0cc835e2e3853df3d8d8408a9c1fc77cb7cdb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd55571db9efa6fd7fdd37e3a7183a97ee81386c7685760444a93e520ed12678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "501513c9d8d33977b177e03ed70980ae2cc2a6a5843c92ca23a854726d8ef5be"
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
