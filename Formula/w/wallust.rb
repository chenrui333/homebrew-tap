class Wallust < Formula
  desc "Better pywal"
  homepage "https://explosion-mental.codeberg.page/wallust/"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.4.0.tar.gz"
  sha256 "2fa1b604a70026ff9ed853cc43bb5d4bed6c17ea1a0cea08563447bd5df5ddfb"
  license "MIT"
  head "https://codeberg.org/explosion-mental/wallust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3279a1d19cff08b2d94333d18157f5315fe179ec9c139ad623badd55592cf60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d4ff3eb56f5525867106c9d05e90335319d051643158e234d9f9ba9c6d85fe"
    sha256 cellar: :any_skip_relocation, ventura:       "6af9be1d176a9be754d4e9db63580b168101a3ff9af4797e41333cdeff55da05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2ee5137690cdc0d63352da4cb1ce1d20a5f55aae83f2906de51ed3fac6d93a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/wallust.bash" => "wallust"
    zsh_completion.install "completions/_wallust"
    fish_completion.install "completions/wallust.fish"
    man1.install Dir["man/*.1"]
    man5.install "man/wallust.5"
  end

  test do
    resource "test_image" do
      url "https://rustfoundation.org/wp-content/uploads/2024/07/cropped-rust-lang-logo-black-300x300.png"
      sha256 "62df7205f3fc29db0a47bbd328789d64325bd88ea62b0bcc7418589dca7337c4"
    end

    testpath.install resource("test_image")
    system bin/"wallust", "run", testpath/"cropped-rust-lang-logo-black-300x300.png"
    system bin/"wallust", "--version"
  end
end
