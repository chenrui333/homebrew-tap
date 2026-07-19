class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5106841ed91cb650f4294c9a2bc472c7fa3b43e61e41f814c1a907a0140a9375"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff2ec0475052743677bbd8e18aa9f294d509145160a6b9f2c37924100d12184c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aaa62244eee7eaf30b9ac8ae7d70a0f6bdc44441d93d92e427c429a753e517f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6743a4c5f49bb08744189e4c36f086eebe21bfd71dad0bad09438984121842"
    sha256 cellar: :any,                 arm64_linux:   "16c86fea598c494c6be5884c57e6258f544152c635680aa31f13147445ab6049"
    sha256 cellar: :any,                 x86_64_linux:  "b599a03268951d463ecc57493d3e3352656a25a78bd8bc2dfc614a18e3faa00a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath/"scores.csv"}")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
