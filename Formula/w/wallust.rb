class Wallust < Formula
  desc "Better pywal"
  homepage "https://codeberg.org/explosion-mental/wallust"
  url "https://codeberg.org/explosion-mental/wallust/archive/3.3.0.tar.gz"
  sha256 "95f5aeb108e6a9926bb2390b0e9ba3071a5fcd2a4c48e45fc1dfc96a2fd6c20b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ceca5e303286b5fc4a6e05faeafa736dabf8d10621b5ad8ef0d128eae613e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b638e07805af726f5a3d916ddcbad464d120c7c791d5a2111f953bf8bfe0177"
    sha256 cellar: :any_skip_relocation, ventura:       "fb5b55a06bc868e3d42dc6bbdcedb0fd106aa0af51e46a4a1aa6dd2670981ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523bada40275c6616013cc400041885212a323e0525da3521e235f54ed1ac2e3"
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
