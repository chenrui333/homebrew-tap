class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "c95cc60ac2e1785b9150e995c71dff9bc42be0a70a34291fb6399bf6ffcd7b93"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "11db3effa9a70413d8a8819478505bdbdb75677deb7837265c592833a9109126"
    sha256                               arm64_sequoia: "1b719eeeb120e142fd17e730c56d80085882621fd5a890ce7586d22b7df02d05"
    sha256                               arm64_sonoma:  "e4c14abacd59b71f7413c838bbf85ca9ee18a58771dfc51433d14a32497a3ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694584406421af49c94ac750236074997e1f2100e802c1e9afcc0709234c1fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b232ca5662e9ee014b12dbea52f6def568e608bfb1079be6a4534e752b3318"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
