class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.1.3.tar.gz"
  sha256 "4997bbb6dd1a10028d7ddeec795a5998e1ebbb517a1926832f5cd5711d0ea783"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4791285a6c9c4c46c6ddc87604eb5e801b69cc148708ab16d90ec4bec237882e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd41aa5b40c662292469f7027e151c7edabc341d445c5b429b634adcdfaeb59"
    sha256 cellar: :any_skip_relocation, ventura:       "b8a864a93308982c0d98b15bb98bd6d0f9216f3e748a73df71ea9962cc61067e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b034f6d50c72a158a2de30216c40a0c0ec7949743196368e320e377bbfb6efb"
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
