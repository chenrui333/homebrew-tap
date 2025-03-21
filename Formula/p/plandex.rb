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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397123797b2d7e24e7bfb449fdac42fb476ca498e6383708335e68bfb1a60e41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acb09ad92b84d4bc9bb5ab14ab143a251112c9b3f219d56187c3e930e2740158"
    sha256 cellar: :any_skip_relocation, ventura:       "45a7e1d63a7a566c84f685e889412e29336850615a2e0424ed715605471f7b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbba206d6cf999142f81641c2b8710e52decfa8e8ae8f01c9efe95fbf45f48e3"
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
