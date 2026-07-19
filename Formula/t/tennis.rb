class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5106841ed91cb650f4294c9a2bc472c7fa3b43e61e41f814c1a907a0140a9375"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "658628b93a7900c96635ac6f22f307e8d2691d4ff56fbee51c63faf3bf3b209c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6cfd1ca0050d1b7509bd03b6e10b0fd7a4cdc1171ad9d1a2e128d88576a5e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7bfe055a2afe34dadf688fcbce7cce753b00a735523157c16d40e0d82acfc8f"
    sha256 cellar: :any,                 arm64_linux:   "2da44e5e45b319a6987498a7799c720cd3601a61f82fb5c75a8f573f0a0ecd61"
    sha256 cellar: :any,                 x86_64_linux:  "83066e22dc15695e4720a98e2ef570732545fe396f106fc0d53d10000d92d64a"
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
