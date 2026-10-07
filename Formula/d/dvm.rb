class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://github.com/justjavac/dvm"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "a2c1ed50c4e787a8fc923861117c02387bdbde93581df24c7090ad42004e0ac0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eac4bc432a84b6c7492e8930a2d8f7d1030d554307427426da3c89558c12f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c35da4967d688d5a1923e9eac7b0497b04776f77c9b59df572410fafc72739c"
    sha256 cellar: :any,                 arm64_linux:   "babfc6fd3b76e09787366239bc69ada283d982b16cf09486366d7435110df576"
    sha256 cellar: :any,                 x86_64_linux:  "e80b5918896ead9b650f59c2ddc1a36e4bafb49f7d1e0f618f0427807f924cab"
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
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    output = shell_output("#{bin}/dvm info")
    assert_match "dvm #{version}", output
    assert_match(/^deno\s+\S+$/, output.lines[1].chomp)
    assert_match "dvm root #{Dir.home}/.dvm", output

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
