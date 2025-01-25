class Wallust < Formula
  desc "Better pywal"
  homepage "https://codeberg.org/explosion-mental/wallust"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.1.0.tar.gz"
  sha256 "dd5cbc69a04011e4770ed9e1d53703d149655a87cd1d1bb4fd52fe692c5022bd"
  license "MIT"

  bottle do
    root_url "https://github.com/chenrui333/homebrew-tap/releases/download/wallust-3.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c9960c902496fc28ebff13ff550f02fede43e4d4f2848052db941203edd77fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f596f6b39952a45beacb10c73e4a724529ec84473093ab085f0f1da6fc3dd9"
    sha256 cellar: :any_skip_relocation, ventura:       "66fe3445b8c4406e2e347829656a59c5dff6a6e0e7b21aa710547fced1fb236f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698fca8acc79ae44e89a3e112d0d01fc57e78fd949b31c44b2ac1670981ab9c0"
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
