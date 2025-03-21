class Plandex < Formula
  desc "AI driven development in your terminal. Designed for large, real-world tasks"
  homepage "https://plandex.ai/"
  url "https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v2.0.2.tar.gz"
  sha256 "31432f1857be03b34c3ace1a90bc070122328bf2e56a3e0c9b6789812aa247cc"
  license "MIT"
  head "https://github.com/plandex-ai/plandex.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "914a678f26bd619eccd7561f5e3ce7798b17179d187b8ffd0b0eaabb8e145439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38871e015413f6925b9dfc9be987d5fe91c31818127cfb7d1b2d4fb8920d796d"
    sha256 cellar: :any_skip_relocation, ventura:       "73421d2b43397990fd04f97c9e445a14561dba458964efe91aa92fb1371c6176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875fb8a76aec517d7eeb031142a73a79b45b3e111c686a343b4d19c979b3618e"
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
