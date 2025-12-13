class Wallust < Formula
  desc "Better pywal"
  homepage "https://explosion-mental.codeberg.page/wallust/"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.4.0.tar.gz"
  sha256 "2fa1b604a70026ff9ed853cc43bb5d4bed6c17ea1a0cea08563447bd5df5ddfb"
  license "MIT"
  head "https://codeberg.org/explosion-mental/wallust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2ef50df3c0f87cf7aa3ead5939dc78bc494936e4e59256cecd06aaf4e1c4ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcfccb4881e36896c5c973318f9fe19633e272d56ea62e2c54712bbce15a4ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525f8b1779255afa9d85bb44b89de9d182d809a5d162352947114e4e3c0fe382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "358f7b786dffddcd4eaf53d327b9213c151dfc84af546569ca3b3ca5077892c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e84bc9e1562e38ee451ae5c234af15177b1d0a2412b2ca40d2edb8c60d2d3ab"
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
