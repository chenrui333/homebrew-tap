class Oatmeal < Formula
  desc "TUI to chat with large language models"
  homepage "https://github.com/dustinblackman/oatmeal"
  url "https://github.com/dustinblackman/oatmeal/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dee11f69eabc94adeb58edc5ecf5b51556bd4dec3a6a3d66c3a5e603aa8a0256"
  license "MIT"
  head "https://github.com/dustinblackman/oatmeal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71afa42d950702d109a5e6a07aa72e0c85022f11feb5bd9822226ca5f1f8a8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca662830c08fe280aed3ff5a4416932bb545a5c6482206ee5287ba7a5e308270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920878067d9b1448645c43ee3611ad08f00c47e9506cc69caead33183a5bb0e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f366ecd59256ea9d905f0955f62315175f1028573638a450732e9ce8d52a9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8834fd16d76f34f2d9114e020d4005d5b55c1d17754133bbea734c4356e6b85b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "update", "-p", "time"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"oatmeal", shell_parameter_format: :clap)
    (man1/"oatmeal.1").write Utils.safe_popen_read(bin/"oatmeal", "manpages")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oatmeal --version")
    output = shell_output("#{bin}/oatmeal config default")
    assert_match "# The initial backend hosting a model to connect to", output
  end
end
