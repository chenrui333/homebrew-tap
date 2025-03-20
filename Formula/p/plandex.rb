class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.1.tar.gz"
  sha256 "01e79ed548a080eb4231997c8b0a9939846222bbf10086e7829605bf962698dd"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0935eb5e4ee484d8f2aee6243826c9dde41d521d018c1dff602ad12a13e3320f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3539304aa659d00edf04b0d81267d02b6cd3df8c54bbfa07a7ec8228053e183"
    sha256 cellar: :any_skip_relocation, ventura:       "04299c96034eec806ce0eab8fa06f3e045d041fb5b752437512c33b657367f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80964208396da7f864c626cd6e70943229475916c41ec19a6ce8590b2dc04a60"
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
