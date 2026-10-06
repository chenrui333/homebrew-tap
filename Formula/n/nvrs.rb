# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.koi.rip/"
  url "https://github.com/koibtw/nvrs/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "67305ede8d833c1c7d449863c904c485ed3cf9ae32b9f976bfaee5108ad244b8"
  license "MIT"
  head "https://github.com/koibtw/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10669ba00e469a617a2eb9bed8b55fa698fb696979eba8258528960a575e0dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a9b0ae387fe16feadc37b86a4f51f2e3d53d62b0b8cd5e44116bfb1aadd4d7c"
    sha256 cellar: :any,                 arm64_linux:   "fa06df1587dafd7f80af1c99fac5b76b230240f3da2293387afb1a50a48c3d68"
    sha256 cellar: :any,                 x86_64_linux:  "bf87b31c929a1104344a65fabfc3e17a4e0d91e514b0213e82b7a37565476bef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args

    pkgshare.install "nvrs.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvrs --version")

    (testpath/"nvrs.toml").write <<~TOML
      [__config__]
      oldver = "oldver.json"
      newver = "newver.json"

      [brewtest]
      source = "shell"
      shell = "echo 1.2.3"
    TOML

    assert_match "brewtest NONE -> 1.2.3", shell_output(bin/"nvrs")
    assert_match "brewtest NONE -> 1.2.3", shell_output("#{bin}/nvrs --take brewtest")
    assert_equal "1.2.3", JSON.parse((testpath/"oldver.json").read).dig("data", "brewtest", "version")
  end
end
