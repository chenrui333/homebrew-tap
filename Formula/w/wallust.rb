class Wallust < Formula
  desc "Better pywal"
  homepage "https://explosion-mental.codeberg.page/wallust/"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.5.2.tar.gz"
  sha256 "46c2592217f0de968437850b14b2e844f2af4158b70135b2b448dc426c0309a1"
  license "MIT"
  head "https://codeberg.org/explosion-mental/wallust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b276b0d7cf7117c7e322f877e7877fd921f1f5a185629e659a2cf0af7ddd012a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c4af12dad6b39a05accb551e5b45a277e1053a8b2d6f9aaf5c38cc0898af777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8579fe4c620f6f63fca82b33a0ea96f79c200c857e6a90106c39e20bf50b1e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05339d3809a3c682dbeb1db6bdde0ccef8a462e9c4673f025a87ab4563a0b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e3fa4953127c06c69a9d4b0a6ad1e43804f2b55cb480f3c3e2c1d64ab525fb"
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
