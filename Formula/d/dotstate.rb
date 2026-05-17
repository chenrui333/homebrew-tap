class Dotstate < Formula
  desc "Modern and secure dotfile manager"
  homepage "https://dotstate.serkan.dev"
  url "https://github.com/serkanyersen/dotstate/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "a19bf5f2a76aaca85a83a78ab732b40cb32c584785a6586cd373713e005c3283"
  license "MIT"
  head "https://github.com/serkanyersen/dotstate.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7fe113b67b3f0af11bc210fbb98362aff0ba8bec203df8e26374e355140f65dd"
    sha256                               arm64_sequoia: "13bb6487703549f748d32468c55618a61e778316b173e96cdad4f7afee0d880e"
    sha256                               arm64_sonoma:  "80283db5bea82aea87618d1aca85ec0cf9eb3a2328345309eb69dcb6d7595b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab7f153f015b24b8947170ce65e57d45e0318af880a336a05e9adc2ea996994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fae8383e980aba9fe1921cc5b32230ba2939b845df380671069eaec8d100635"
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
