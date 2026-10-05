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
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "320e46724cda556c52397dfa2b3a28ed54052dbb137fae190c51cd74b05303fa"
  end

  deny_network_access!

  def install
    bin.install "llmpeg"
  end

  test do
    # Without a key the script stops before calling the OpenAI or Groq APIs.
    ENV.delete("OPENAI_API_KEY")
    ENV.delete("GROQ_API_KEY")
    output = shell_output("#{bin}/llmpeg remove audio from example.mov 2>&1", 1)
    assert_match "No API key found", output

    assert_match "Requires a prompt", shell_output("#{bin}/llmpeg 2>&1", 1)
  end
end
