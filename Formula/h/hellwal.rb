class Hellwal < Formula
  desc "Pywal-like color palette generator, but faster and in C"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a33d1c5257fe4b42e92cac7f055c6ed1a3e857fe52ab435924b316947d55e200"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "778d679a53cef4dbd676f5d05ece0bf8146b009406c00aa987128d657dbca040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a57e8ca0e7843579ac344724f45e606d781038fd47feb2af03223dd85ba82eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8df8b8cfcb4f5c70d1ca34d2cd601aa6085e641bb8de19b52a230e07cb78d1"
  end

  depends_on macos: :sonoma # failed on ventura

  def install
    system "make"
    bin.install "hellwal"
    doc.install "templates", "themes"
  end

  test do
    resource "test_image" do
      url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/486af5b4f6eee92b2f14ffd02db0c60ab2287555/assets/cropped-rust-lang-logo-black-300x300.png"
      sha256 "62df7205f3fc29db0a47bbd328789d64325bd88ea62b0bcc7418589dca7337c4"
    end

    testpath.install resource("test_image")
    system bin/"hellwal", "--image", testpath/"cropped-rust-lang-logo-black-300x300.png"

    system bin/"hellwal", "--help"
  end
end
