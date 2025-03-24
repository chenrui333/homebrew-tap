class Wallust < Formula
  desc "Better pywal"
  homepage "https://codeberg.org/explosion-mental/wallust"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.3.0.tar.gz"
  sha256 "95f5aeb108e6a9926bb2390b0e9ba3071a5fcd2a4c48e45fc1dfc96a2fd6c20b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8fbe9efc49207f7d9cc9fc477d00d37a5423ea988778c4911ca51fd748119b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c245490897144c92fdec09669be92196c5253c502795f4ce5f9f3fb250fa67"
    sha256 cellar: :any_skip_relocation, ventura:       "4be42ef780dbcbcff59adc50755fe9c922d506cec1476f8c99cb27d134a5d27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19e5e90dcb6894cfd609c2eb402109a988629bc8fdeab11ae9cd3c9bb4ebda5"
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
