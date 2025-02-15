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

  def install
    bin.install "llmpeg"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/llmpeg remove audio from example.mov 2>&1", 1)
    assert_match "Error: No command generated or API response is empty", output
  end
end
