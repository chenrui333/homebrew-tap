class Llmpeg < Formula
  desc "Uses an llm to generate ffmpeg commands"
  homepage "https://github.com/jjcm/llmpeg"
  url "https://github.com/jjcm/llmpeg/archive/d2e0c5e01caede261a5071749ebf47e1f95fe3c3.tar.gz"
  version "0.0.0"
  sha256 "919ffed949fa2b3f10ff697707c7c1321a39c282d4a79964d9cd40b7a94d70aa"
  license "MIT"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "340e618d948834af6a0d1ffbc9b15cb1fad4cab215f5a95179759e13d54d78f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191ec8ab2165c7a8c62db593620d5cd0255f1fc38eb1415d7ccc5cd30b631bd9"
    sha256 cellar: :any_skip_relocation, ventura:       "2d238f93f30f1737fdcc6c91ed185d462b6b30595d8ad74f38a57d80677decf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb50ccdd29255c5928b164204194674d4c4d12aa2e270e875f15748101798aa2"
  end

  def install
    bin.install "llmpeg"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/llmpeg remove audio from example.mov 2>&1", 1)
    assert_match "Error: No command generated or API response is empty", output
  end
end
