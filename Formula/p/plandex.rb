class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.6.tar.gz"
  sha256 "84c7a80119ea552b3e5cc77b92a8f9ba39dc9722b2a1f4ce4b87882aca04f94e"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a05fbfddc6ccdf2ae3157cc5f1b976d34a4659cba50e538d32328e09d8061b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84f0522ab51d37f08b6780cdd86a43dc1dcfb6b3f994ce7598266447cf372a2a"
    sha256 cellar: :any_skip_relocation, ventura:       "bc4c7d811ef73f6ed35c3b06e729d8c3772c4c2996b019b84b351905c634f41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbffe47ba67a803e4c6051cab3c5f5bbc3e95a9161c810b76d3a43caae4be4b"
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
