class Wallust < Formula
  desc "Better pywal"
  homepage "https://codeberg.org/explosion-mental/wallust"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.2.0.tar.gz"
  sha256 "6527062fe2819ff0f6a1784e7e42f56d27cc97916411b764bbe6b2acdd26b97d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc2ee0b2e715d8290fa13413686fa76d67ebf75b23bd4447957d4a27218d8b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d73ade2ee8696d7f10880d02c97aa7cbb89aebd55b67530c3a296c3ab01ca47"
    sha256 cellar: :any_skip_relocation, ventura:       "1bc75cf6a289f179f845f973a984f3a05abe70d38b837d7c489f5fc4d1ecd2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e8746d52ae2e6634466908debc276956562aafd10156b3f4f5e9c8044c02f6"
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
