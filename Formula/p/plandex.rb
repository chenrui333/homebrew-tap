class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.6.tar.gz"
  sha256 "32a6e59957935dfdfd118fd91c7ac57b0175a0334ac5d847e17cc29231b0f8cb"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c463e4213b059b88f2a002e26decd9e96118560c40edcf4d3ac28ad3db6e1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39fec68e545e8a8133346f116ee5e5bdfb7cccc4845e1fb99cf916bdb4aabd85"
    sha256 cellar: :any_skip_relocation, ventura:       "7379e0769970dac977ffa8d968c32c7731daa49dd1a1f4cff13c619a38d94d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a901d533e1f45d99f706806848d0f5dd5b2f88ff0db4125a86e305a509c8b2fe"
  end

  depends_on "go" => :build

  def install
    cd "app/cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X plandex-cli/version.Version=#{version}")
      generate_completions_from_executable(bin/"plandex", "completion")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plandex version")

    # now it has annoying
    # # ? 👋 Hey there!
    # # It looks like this is your first time using Plandex on this computer.
    # # What would you like to do?
    # # > Start a trial on Plandex Cloud
    # #   Sign in, accept an invite, or create an account
    # system bin/"plandex"
  end
end
